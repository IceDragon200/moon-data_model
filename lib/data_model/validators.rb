require 'data_model/validators/base'

module Moon
  module DataModel
    # Various Validators usable by {Field}
    module Validators
      # @return [Hash<Symbol, Validator::Base<>>]
      @registry = {}

      # Registers a Validator
      # @param [Symbol] key
      # @param [Validator::Base] validator
      def self.register(key, validator)
        @registry[key] = validator
      end

      # Fecthes a validator by key
      #
      # @param [Symbol] key
      # @return [Validator::Base] the validator
      def self.fetch(key)
        @registry.fetch(key)
      end
    end
  end
end

require 'data_model/validators/type'
