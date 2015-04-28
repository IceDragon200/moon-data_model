require 'data_model/err'
require 'data_model/type'

module Moon
  module DataModel
    module TypeValidators
      module Base
        private def check_object_class(expected, given, options = {})
          unless given.is_a?(expected)
            if options[:quiet]
              return false
            else
              raise TypeValidationError, "wrong type #{given.class.inspect} (expected #{expected.inspect})"
            end
          end
          true
        end

        def ensure_type(type)
          unless type.is_a?(Moon::DataModel::Type)
            raise TypeError, "wrong type #{type} (expected a #{Moon::DataModel::Type})"
          end
        end

        def check_type(type, value, options = {})
          ensure_type type

          do_check type, value, options
        end
      end
    end
  end
end
