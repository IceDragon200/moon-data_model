require 'data_model/model'

module Moon
  # Moon::DataModel serves as the base for most structured data types in Moon
  module DataModel
    # Metal is a generic implementation of Moon::DataModel::Model
    class Metal
      include Model

      # @return [Integer] DataModel id counter
      @@dmid = 0

      # @return [Integer] Generic DataModel id
      attr_reader :dmid

      # @param [Hash<Symbol, Object>] opts
      #   Values to initialize the model with
      def initialize(opts = {})
        @dmid = @@dmid += 1
        initialize_fields(opts)
        yield self if block_given?
        post_init
      end

      # Final initialization method
      private def post_init
        #
      end

      # Converts to a Hash
      #
      # @return [Hash<Symbol, Object>]
      def to_h
        hsh = {}
        each_pair do |k, obj|
          if obj.is_a?(Array)
            obj = obj.map do |o|
              o.respond_to?(:to_h) ? o.to_h : o
            end
          elsif obj.is_a?(Hash)
            obj = obj.each_with_object({}) do |a, hash|
              k, v = a
              hash[k] = v.respond_to?(:to_h) ? v.to_h : v
            end
          else
            obj = obj.to_h if obj.respond_to?(:to_h)
          end
          hsh[k] = obj
        end
        hsh
      end

      # @param [Symbol] key
      # @param [Object] value
      # @return [Object]
      private def custom_type_cast(key, value)
        raise "#{key}, #{value}"
      end
    end
  end
end
