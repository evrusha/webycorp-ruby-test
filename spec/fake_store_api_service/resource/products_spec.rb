# frozen_string_literal: true

RSpec.describe FakeStoreApiService::Resource::Products, vcr: { cassette_name: 'fetch_product' } do
  let(:client) { FakeStoreApiService::Client.new }
  let(:product_id) { 1 }
  let(:product) { client.product(product_id) }

  describe '#product' do
    it 'returns a product by ID' do
      expect(product).to be_a(Hash)
    end

    it 'returns a product with the correct ID' do
      expect(product['id']).to eq(product_id)
    end

    context 'when checking product attributes' do
      it 'includes the title attribute' do
        expect(product).to have_key('title')
      end

      it 'includes the price attribute' do
        expect(product).to have_key('price')
      end
    end
  end
end
