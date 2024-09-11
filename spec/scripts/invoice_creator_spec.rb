# frozen_string_literal: true

RSpec.describe InvoiceCreator, vcr: { cassette_name: 'invoice_creator' } do
  let(:invoice_creator) { described_class.new }
  let(:user_data) { { 'email' => 'test@example.com', 'name' => { 'firstname' => 'Test', 'lastname' => 'User' } } }
  let(:stripe_customer) { invoice_creator.instance_variable_get(:@stripe)[:customer] }

  it 'creates invoices' do
    expect(invoice_creator.call).not_to be_empty
  end

  describe '#create_or_fetch_customer' do
    context 'when the user exists' do
      before do
        existing_customer_id = '123456'
        allow(stripe_customer).to receive(:list).with(email: user_data['email'])
                                    .and_return(double(data: [double(id: existing_customer_id)]))
      end

      it 'fetches the existing customer' do
        customer_id = invoice_creator.send(:create_or_fetch_customer, user_data)
        expect(customer_id).to eq('123456')
      end
    end

    context 'when the user does not exist' do
      before do
        new_customer_id = '123456n'
        allow(stripe_customer).to receive(:list)
                                    .with(email: user_data['email'])
                                    .and_return(double(data: []))
        allow(stripe_customer).to receive(:create)
                                    .with(name: 'Test User', email: user_data['email'])
                                    .and_return(double(id: new_customer_id))
      end

      it 'creates a new customer' do
        customer_id = invoice_creator.send(:create_or_fetch_customer, user_data)
        expect(customer_id).to eq('123456n')
      end
    end
  end
end
