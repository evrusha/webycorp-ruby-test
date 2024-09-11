# frozen_string_literal: true

module FakeStoreApiService
  module Resource
    # This module provides methods for interacting with the "products" resource of the Fake Store API.
    module Products
      def product(id)
        response = get("/products/#{id}")
        response.body
      end
    end
  end
end
