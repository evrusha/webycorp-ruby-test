# frozen_string_literal: true

RSpec.describe FakeStoreApiService::Client, :vcr do
  let(:client) { described_class.new }
  let(:valid_url) { '/users/1' }
  let(:invalid_url) { '/invalid_endpoint' }

  describe '#get' do
    context 'when the request is successful' do
      it 'returns a response with status 200' do
        VCR.use_cassette('successful_request') do
          response = client.get(valid_url)
          expect(response.status).to eq(200)
        end
      end
    end

    context 'when the request fails' do
      it 'returns a response with error' do
        VCR.use_cassette('failed_request') do
          expect { client.get(invalid_url) }.to raise_error(Faraday::Error)
        end
      end
    end
  end
end
