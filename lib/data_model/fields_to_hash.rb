module Moon
  module DataModel
    # Specialized module for dumping Fields recursively
    module FieldsToHash
      # @param [Object] obj
      # @param [Integer] depth  recursion tracking
      # @return [Object] dumped object
      def self.dump_object(obj, depth = 0)
        case obj
        when Array
          dump_array(obj, depth + 1)
        when Hash
          dump_hash(obj, depth + 1)
        else
          obj.respond_to?(:to_h) ? obj.to_h : obj
        end
      end

      # Recursively dumps the contents of the Hash
      #
      # @param [Hash] hsh
      # @param [Integer] depth  recursion tracking
      # @return [Hash]
      def self.dump_hash(hsh, depth = 0)
        hsh.each_with_object({}) do |a, result|
          key, value = *a
          result[key] = dump_object(value, depth + 1)
        end
      end

      # Recursively dumps the contents of the Array
      #
      # @param [Array] ary
      # @param [Integer] depth  recursion tracking
      # @return [Array]
      def self.dump_array(ary, depth = 0)
        ary.map { |elem| dump_object(elem, depth + 1) }
      end

      # Dumps all the record's fields as basic ruby primitives
      #
      # @param [DataModel::Fields] record
      # @return [Hash]
      def self.call(record)
        result = {}
        record.each_field_with_value do |key, field, obj|
          result[key] = if field.type.array?
            dump_array(obj)
          elsif field.type.hash?
            dump_hash(obj)
          else
            dump_object(obj)
          end
        end
        result
      end
    end
  end
end
