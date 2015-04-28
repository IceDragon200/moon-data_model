require 'data_model/err'

module Moon
  module DataModel
    module Validators
      # Base class for validators
      class Base
        # @param [Hash<Symbol, Object>] options
        def initialize(options)
          pre_initialize
          initialize_options(options)
          post_initialize
        end

        # Called before options are initialized
        #
        # @return [void]
        def pre_initialize
        end

        # Initialize the Validator from the provided options
        #
        # @param [Hash] options
        # @return [void]
        def initialize_options(options = {})
        end

        # Called after options are initialized
        #
        # @return [void]
        def post_initialize
        end

        # Checks if the given value is a valid
        #
        # @param [Object] value  object to validate
        # @return [Boolean] whether the value is valid or not.
        def valid?(value)
          true
        end

        # Checks if the given value is valid, raises a {ValidationFailed} if
        # not.
        #
        # @param [Object] value  object to validate
        def validate(value)
          raise ValidationFailed unless valid?(value)
        end

        # see also {Field#initialize_validators}
        #
        # @param [Symbol] key  name that this validator should be known as
        def self.register(key)
          @registered = key
          Validators.register key, self
        end

        class << self
          protected :register
        end
      end
    end
  end
end
