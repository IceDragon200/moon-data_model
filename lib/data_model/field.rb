require 'data_model/type'
require 'data_model/validators'

module Moon
  module DataModel
    class Field
      # @return [Symbol] name of the field
      attr_reader :name
      # @return [Array, Hash, Class] type
      attr_reader :type
      # @return [Proc, Object] default
      attr_reader :default
      # @return [Boolean] allow_nil  are nils allowed for the value?
      attr_reader :allow_nil
      # @return [Boolean] is_key  Is this a key field (such as an id)?
      attr_reader :is_key
      # @return [Array<Validator::Base<>>]
      attr_reader :validators

      # @param [Hash<Symbol, Object>] options
      # @option options [Symbol] :name
      #   Name of the field
      # @option options [Object] :type
      #   An object that can be transformed into a DataModel::Type
      # @option options [Boolean] :allow_nil
      #   Does this field allow nil values?
      # @option options [Boolean] :is_key
      #   Mark this field as the `key` field
      # @option options [Hash<Symbol, Object>] :validate
      #   Validation parameters, keys are the name of the validator
      #   and their values are the parameters for that validator.
      def initialize(options)
        @name       = options.fetch(:name)
        initialize_type(options.fetch(:type))
        @default    = options.fetch(:default, nil)
        @allow_nil  = options.fetch(:allow_nil, false)
        @is_key     = options.fetch(:is_key, false)
        initialize_validators(options.fetch(:validate, []))
      end

      # @return [void]
      def finalize
        @type.finalize
      end

      # @param [Object] type
      # @return [void]
      private def initialize_type(type)
        @type = Moon::DataModel::Type[type]
      end

      # @param [Hash<Symbol, Object>] validators
      # @return [void]
      private def initialize_validators(validators)
        @validators = []

        v = validators.find { |v| v.is_a?(Validators::Type) }
        unless v
          type_validator = Validators.fetch(:type).new(type: @type)
          @validators = [type_validator].concat(@validators)
        end
      end

      def coerce(value)
        @type.coerce(value)
      end

      def make_default(model = nil)
        @default.is_a?(Proc) ? @default.call(@type, model) : @default
      end

      def run_validators(value, quiet = false)
        @validators.each do |validator|
          validator.validate(value)
        end
      end

      def validate(value, quiet = false)
        run_validators(value, quiet)
      end

      def self.default_proc
        lambda do |type, _|
          # Integer, Numeric and Float cannot be created using .new
          if type.model == Integer then 0
          elsif type.model == Numeric then 0
          elsif type.model == Float then 0.0
          else
            type.model.new
          end
        end
      end

      alias :is_key? :is_key
      alias :allow_nil? :allow_nil
    end
  end
end
