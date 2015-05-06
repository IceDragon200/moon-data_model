require 'data_model/model'
require 'data_model/fields_to_hash'

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
      # before its fields are initialized.
      #
      # @return [void]
      def pre_initialize
      end

      # Final initialization method, use this as your own initialize method.
      # Called after the fields have been initialized at the very end.
      # if you need to change the model before it ever reaches the user
      # use {Fields::InstanceMethods#post_initialize_fields} instead.
      #
      # @return [void]
      def post_initialize
      end

      # Converts the Model to a Hash, all fields will be converted to Hashes
      # via #to_h
      #
      # @return [Hash<Symbol, Object>]
      def to_h
        FieldsToHash.call(self)
      end
    end
  end
end
