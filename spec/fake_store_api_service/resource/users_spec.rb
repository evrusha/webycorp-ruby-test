# frozen_string_literal: true

RSpec.describe FakeStoreApiService::Resource::Users, vcr: { cassette_name: 'fetch_user' } do
  let(:client) { FakeStoreApiService::Client.new }
  let(:user_id) { 1 }

  describe '#user' do
    it 'returns a user by ID' do
      result = client.user(user_id)
      expect(result).to be_a(Hash)
    end

    it 'returns a user with the correct ID' do
      result = client.user(user_id)
      expect(result['id']).to eq(user_id)
    end

    context 'when checking user attributes' do
      it 'includes the name attribute' do
        result = client.user(user_id)
        expect(result).to have_key('name')
      end

      it 'includes the email attribute' do
        result = client.user(user_id)
        expect(result).to have_key('email')
      end
    end
  end
end
