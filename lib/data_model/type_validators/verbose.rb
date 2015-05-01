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
          content_types = type.content.map { |k| Moon::DataModel::Type[k] }
          value.each_with_index do |obj, i|
            unless matches_any_type?(content_types, obj)
              str = content_types.map { |s| s.model.inspect }.join(", ")
              return false,
                format_err("[#{i}] wrong content type #{obj.class.inspect} (expected #{str})",
                           options[:ctx])
            end
          end
          return true, nil
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_array_type(type, value, options = {})
          s, m = *check_object_class(type.model, value, options)
          return s, m unless s
          check_array_content(type, value, options)
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_hash_content(type, value, options = {})
          content_type = type.content
          key_types = content_type.keys.map { |k| Moon::DataModel::Type[k] }
          key_str = content_type.map { |s| s.inspect }.join(", ")
          value.each do |k, v|
            unless matches_any_type?(key_types, k)
              return false,
                format_err("wrong Hash key (#{k}) of type #{k.class.inspect} (expected #{key_str})",
                           options[:ctx])
            end
            value_type = Moon::DataModel::Type[content_type[k.class]]
            s, m = check_type(value_type, v, options)
            return s, m unless s
          end
          return true, nil
        end

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def check_hash_type(type, value, options = {})
          s, m = *check_object_class(type.model, value, options)
          return s, m unless s
          check_hash_content(type, value, options)
        end

        extend self
      end
    end
  end
end
