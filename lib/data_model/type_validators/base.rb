require 'data_model/err'
require 'data_model/type'

module Moon
  module DataModel
    module TypeValidators
      # Base module for all TypeValidators
      module Base
        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        protected def check_object_class(expected, given, options = {})
          unless given.is_a?(expected)
            if options[:quiet]
              return false
            else
              raise TypeValidationError, "wrong type #{given.class.inspect} (expected #{expected.inspect})"
            end
          end
          true
        end

        # Ensures that the object given is a {Type}
        #
        # @param [Type] type
        protected def ensure_type(type)
          unless type.is_a?(Moon::DataModel::Type)
            raise TypeError, "wrong type #{type} (expected a #{Moon::DataModel::Type})"
          end
        end

        # Checks the value against the provided type
        #
        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @option options [Boolean] :quiet  suppress raise errors
        # @return [Boolean]
        def check_type(type, value, options = {})
          ensure_type type

          do_check type, value, options
        end
      end
    end
  end
end
