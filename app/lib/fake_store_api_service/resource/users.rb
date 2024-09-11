# frozen_string_literal: true

module FakeStoreApiService
  module Resource
    # This module provides methods for interacting with the "users" resource of the Fake Store API.
    module Users
      def user(id)
        response = get("/users/#{id}")
        response.body
      end
    end
  end
end
