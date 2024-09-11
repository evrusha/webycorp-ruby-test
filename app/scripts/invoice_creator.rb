# frozen_string_literal: true

# This class handles the creation of invoices by interacting with Stripe's API.
# It fetches cart and product data from the FakeStore API,
# creates necessary Stripe objects (customers, products, prices, invoice items),
# and generates invoices for each cart.
# The process includes creating customers, adding products and prices to invoices, and finalizing them.
class InvoiceCreator
  def initialize
    @stripe = {
      customer: Stripe::Customer,
      product: Stripe::Product,
      price: Stripe::Price,
      invoice_item: Stripe::InvoiceItem,
      invoice: Stripe::Invoice
    }
    @fake_store_api = FakeStoreApiService::Client.new
    @user_cache = {}
  end

  def call
    carts = @fake_store_api.carts
    carts.each do |cart|
      process_cart(cart)
    end
  end

  private

  def process_cart(cart)
    user_data = @fake_store_api.user(cart['userId'])
    customer_id = create_or_fetch_customer(user_data)
    invoice_items = create_invoice_items(cart['products'], customer_id)
    invoice_id = create_draft_invoice(customer_id)
    add_invoice_items(invoice_id, invoice_items)
    finalize_invoice(invoice_id)
  end

  def create_or_fetch_customer(user_data)
    email = user_data['email']
    @user_cache[email] ||= begin
      existing_customers = @stripe[:customer].list(email: email)
      if existing_customers.data.any?
        existing_customers.data.first.id
      else
        @stripe[:customer].create(
          name: user_data['name'].values.join(' '),
          email: email
        ).id
      end
    end
  end

  def create_invoice_items(products, customer_id)
    products.map do |product|
      product_data = @fake_store_api.product(product['productId'])
      stripe_product_id = create_product(product_data)
      price_id = create_price(stripe_product_id, product_data['price'])
      create_invoice_item(customer_id, price_id, product['quantity']).id
    end
  end

  def create_product(product_data)
    @stripe[:product].create(name: product_data['title']).id
  end

  def create_price(product_id, amount)
    @stripe[:price].create(
      unit_amount: (amount * 100).to_i,
      currency: 'usd',
      product: product_id
    ).id
  end

  def create_invoice_item(customer_id, price_id, quantity)
    @stripe[:invoice_item].create(
      customer: customer_id,
      price: price_id,
      quantity: quantity
    )
  end

  def create_draft_invoice(customer_id)
    @stripe[:invoice].create(
      customer: customer_id,
      auto_advance: false
    ).id
  end

  def add_invoice_items(invoice_id, invoice_items)
    @stripe[:invoice].add_lines(invoice_id, lines: invoice_items.map { |id| { invoice_item: id } })
  end

  def finalize_invoice(invoice_id)
    @stripe[:invoice].finalize_invoice(invoice_id)
  end
end
