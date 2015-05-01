require 'data_model/err'
require 'data_model/type'
require 'data_model/message_format'

module Moon
  module DataModel
    module TypeValidators
      # Base module for all TypeValidators
      module Base
        include MessageFormat

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        protected def check_object_class(expected, given, options = {})
          return true, nil if given.is_a?(expected)
          msg = format_err("wrong type #{given.class.inspect} (expected #{expected.inspect})",
                           options[:ctx])
          return false, msg
        end

        # Ensures that the object given is a {Type}
        #
        # @param [Type] type
        protected def ensure_obj_is_a_type(type)
          return if type.is_a?(Moon::DataModel::Type)
          raise TypeError,
            "wrong type #{type} (expected a #{Moon::DataModel::Type})"
        end

        # Checks the value against the provided type
        #
        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @option options [Boolean] :quiet  suppress raise errors
        # @return [Boolean]
        def check_type(type, value, options = {})
          ensure_obj_is_a_type type
          passed, msg = do_check type, value, options
          return passed, msg if passed || options[:quiet]
          raise TypeValidationError, msg
        end

        # Checks if the given value matches any of the provided types
        #
        # @param [Array<Type>] types
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        def matches_any_type?(types, value, options = {})
          opts = { quiet: true, allow_nil: false }.merge(options)
          types.any? do |t|
            b, _ = *check_type(t, value, opts)
            b
          end
        end
      end
    end
  end
end
