# frozen_string_literal: true

RSpec.describe FakeStoreApiService::Resource::Carts, vcr: { cassette_name: 'fetch_carts' } do
  let(:client) { FakeStoreApiService::Client.new }

  describe '#carts' do
    let(:carts) { client.carts }

    it 'returns a list of carts' do
      expect(carts).to be_an(Array)
    end

    context 'when checking cart attributes' do
      it 'each cart has an id key' do
        expect(carts.first).to have_key('id')
      end

      it 'each cart has a userId key' do
        expect(carts.first).to have_key('userId')
      end
    end
  end
end
