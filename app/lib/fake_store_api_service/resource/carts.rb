# frozen_string_literal: true

module FakeStoreApiService
  module Resource
    # This module provides methods for interacting with the "carts" resource of the Fake Store API.
    module Carts
      def carts
        response = get('/carts')
        response.body
      end
    end
  end
end
