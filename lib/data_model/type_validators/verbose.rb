require 'data_model/type_validators/base'
require 'data_model/err'

module Moon
  module DataModel
    module TypeValidators
      # A recursive TypeValidator, this will check and ensure that sub
      # Arrays and Hashes match their provided Type.
      module Verbose
        include Moon::DataModel::TypeValidators::Soft

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_array_content(type, value, options = {})
          content_type = type.content.map { |k| Moon::DataModel::Type[k] }
          value.each_with_index do |obj, i|
            unless content_type.any? { |t| check_type(t, obj, quiet: true, allow_nil: false) }
              str = content_type.map { |s| s.inspect }.join(", ")
              if options[:quiet]
                return false
              else
                raise TypeValidationError,
                      "[#{i}] wrong content type #{obj.class.inspect} (expected #{str})"
              end
            end
          end
          true
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_array_type(type, value, options = {})
          check_object_class(type.model, value, options)
          check_array_content(type, value, options)
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_hash_content(type, value, options = {})
          content_type = type.content
          key_types = content_type.keys
          key_str = content_type.map { |s| s.inspect }.join(", ")
          value.each do |k, v|
            unless content_type.key?(k.class)
              if options[:quiet]
                return false
              else
                raise TypeValidationError, "wrong Hash key (#{k}) of type #{k.class.inspect} (expected #{key_str})"
              end
            end
            value_type = Moon::DataModel::Type[content_type[k.class]]
            check_type(value_type, v, options)
          end
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_hash_type(type, value, options = {})
          check_object_class(type.model, value, options)
          check_hash_content(type, value, options)
        end

        extend self
      end
    end
  end
end
