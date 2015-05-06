require 'data_model/validators/base'

module Moon
  module DataModel
    # Various Validators usable by {Field}
    module Validators
      # @return [Hash<Symbol, Validator::Base<>>]
      @registry = {}

      # Registers a Validator
      #
      # @param [Symbol] key
      # @param [Validator::Base] validator
      def self.register(key, validator)
        @registry[key] = validator
      end

      # Returns whether or not there is a registered validator for the key.
      #
      # @param [Symbol] key
      # @return [Boolean]
      def self.registered?(key)
        @registry.key?(key)
      end

      # Fecthes a validator by key
      #
      # @param [Symbol] key
      # @return [Validator::Base] the validator
      def self.fetch(key)
        @registry.fetch(key) do
          raise NoSuchValidator, "could not a find a validator for key: #{key}"
        end
      end

      # Returns the validators registry
      #
      # @return [Hash] the current registry
      def self.entries
        @registry
      end
    end
  end
end

require 'data_model/validators/type'
