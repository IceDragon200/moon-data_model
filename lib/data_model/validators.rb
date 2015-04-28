module Moon
  module DataModel
    module Validators
      @registry = {}

      # @param [Symbol] key
      # @param [Validator] value
      def self.register(key, value)
        @registry[key] = value
      end

      # @param [Symbol] key
      def self.fetch(key)
        @registry.fetch(key)
      end
    end
  end
end

require 'data_model/validators/base'
require 'data_model/validators/type'
