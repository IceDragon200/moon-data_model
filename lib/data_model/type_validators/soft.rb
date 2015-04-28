require 'data_model/type_validators/base'
require 'data_model/err'

module Moon
  module DataModel
    module TypeValidators
      module Soft
        include Moon::DataModel::TypeValidators::Base

        def check_array_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        def check_hash_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        def check_normal_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        def do_check(type, value, options = {})
          if value.nil?
            if options[:allow_nil]
              return true
            elsif options[:quiet]
              return false
            else
              raise ArgumentError, "cannot be nil (expects #{type})"
            end
          end

          # validate that obj is an Array and contains correct types
          if type.model == Array
            check_array_type(type, value, options)
          # validate that value is a Hash of key type and value type
          elsif type.model == Hash
            check_hash_type(type, value, options)
          # validate that value is of type
          elsif type.model.is_a?(Module)
            check_normal_type(type, value, options)
          else
            raise InvalidType, "cannot handle #{type.model}"
          end
        end

        private :check_hash_type
        private :check_array_type
        private :check_normal_type

        extend self
      end
    end
  end
end
