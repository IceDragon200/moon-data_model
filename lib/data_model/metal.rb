require 'data_model/model'

module Moon
  # Moon::DataModel serves as the base for most structured data types in Moon
  module DataModel
    # Metal is a generic implementation of Moon::DataModel::Model
    class Metal
      include Model

      # @return [Integer] Global DataModel id, incremented each time a Metal
      #                   based model is created.
      @@dmid = 0

      # @!attribute [r] dmid
      #   @return [Integer] Generic DataModel id
      attr_reader :dmid

      # @param [Hash<Symbol, Object>] options
      #   Values to initialize the model with, each Key value pair should be
      #   a field name and value for the field to initialize with.
      # see also {Fields::InstanceMethods#initialize_fields}
      def initialize(options = {})
        @dmid = @@dmid += 1
        pre_initialize
        initialize_fields(options)
        yield self if block_given?
        post_initialize
      end

      # Pre initialization method, use this as a way to setup the model
      # before its fields are initialized
      #
      # @return [void]
      private def pre_initialize
      end

      # Final initialization method, use this as your own initialize method.
      # Called after the fields have been initialized at the very end.
      # if you need to change the model before it ever reaches the user
      # use {Fields#post_initialize_fields} instead.
      #
      # @return [void]
      private def post_initialize
        #
      end

      # Converts the Model to a Hash, all fields will be converted to Hashes
      # via #to_h
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
