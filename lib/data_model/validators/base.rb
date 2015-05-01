require 'data_model/err'
require 'data_model/message_format'

module Moon
  module DataModel
    module Validators
      # Base class for validators
      class Base
        include MessageFormat

        # @!attribute ctx
        #   @return [Hash<Symbol, Object>] debug context information
        attr_accessor :ctx

        # @param [Hash<Symbol, Object>] options
        def initialize(options)
          pre_initialize
          initialize_options(options)
          post_initialize
        end

        # Returns the registered name of the Validator
        #
        # @return [Symbol]
        def name
          self.class.registered
        end

        # Called before options are initialized
        #
        # @return [void]
        def pre_initialize
        end

        # Initialize the Validator from the provided options
        #
        # @param [Hash] options
        # @option options [Hash] :ctx
        #   Debug context information
        # @return [void]
        def initialize_options(options = {})
          @ctx = options.fetch(:ctx, {})
        end

        # Called after options are initialized
        #
        # @return [void]
        def post_initialize
        end

        # Runs the actual validation here, the first parameter returned is
        # whether or not the validation passed and the second is the reason
        # the validation failed.
        #
        # @param [Object] value
        # @return [Array] valid, message
        # @abstract
        def test_valid(value)
        end

        # Does this value pass the validation?
        #
        # @param [Object] value  object to validate
        # @return [Boolean] whether the value is valid or not.
        def valid?(value)
          b, _ = *test_valid(value); b
        end

        # Checks if the given value is valid, raises a {ValidationFailed} if
        # not.
        #
        # @param [Object] value  object to validate
        def validate(value)
          b, msg = test_valid(value)
          unless b
            raise ValidationFailed,
              format_err("#{name} validation failed: #{msg}", @ctx)
          end
        end

        # @return [Symbol]
        def self.registered
          @registered
        end

        # see also {Field#initialize_validators}
        #
        # @param [Symbol] key  name that this validator should be known as
        def self.register(key)
          @registered = key.to_sym
          Validators.register @registered, self
        end

        class << self
          protected :register
        end
      end
    end
  end
end
