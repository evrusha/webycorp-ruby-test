# frozen_string_literal: true

module FakeStoreApiService
  # Client for interacting with the Fake Store API.
  # This class provides methods for making HTTP GET requests to the Fake Store API.
  #
  # It initializes a Faraday connection to the base URL of the Fake Store API.
  # The `get` method is used to send GET requests to the specified URL.
  # It logs the request and response status and handles any errors that occur during the request.
  class Client

    BASE_URL = 'https://fakestoreapi.com'

    def initialize
      @conn = Faraday.new(url: BASE_URL) { |f| f.response :json }
    end

    def get(url)
      Application.logger.info("Started get: #{BASE_URL + url}")
      response = @conn.get(url)
      Application.logger.info("Status: #{response.status}")
      response
    rescue Faraday::Error => e
      Application.logger.error(e.message)
      raise
    end
  end
end
