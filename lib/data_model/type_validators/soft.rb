require 'data_model/type_validators/base'
require 'data_model/err'

module Moon
  module DataModel
    module TypeValidators
      # A simple TypeValidator which will only ensure that the provided
      # value matches its Type's model, content is not checked
      # Use {Verbose} instead if you need it to check content.
      # This is the default validator.
      module Soft
        include Moon::DataModel::TypeValidators::Base

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        #   (see Base#check_object_class)
        # @return [Boolean]
        protected def check_array_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        #   (see Base#check_object_class)
        # @return [Boolean]
        protected def check_hash_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        #   (see Base#check_object_class)
        # @return [Boolean]
        protected def check_normal_type(type, value, options = {})
          check_object_class(type.model, value, options)
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def do_check(type, value, options = {})
          if value.nil?
            if options[:allow_nil]
              return true, nil
            else
              return false,
                format_err("cannot be nil (expects #{type.model})", options[:ctx])
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
            raise InvalidType,
              format_err("cannot handle #{type.model}", options[:ctx])
          end
        end

        extend self
      end
    end
  end
end
