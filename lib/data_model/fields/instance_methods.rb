require 'moon-serializable/load'
require 'data_model/err'
require 'data_model/field'

module Moon
  module DataModel
    module Fields
      # Instance methods for models
      module InstanceMethods
        include Serializable::Properties::InstanceMethods
        # this allows Fields to behave like Hashes :)
        include Enumerable

        # Initializes a field to its default value
        #
        # @param [Symbol] key  name of the field to initialize
        # @return [void]
        def reset_field(key)
          field = self.class.fetch_field(key)
          field_set key, field.make_default(self)
        end

        # Initializes all available fields for the model with their default
        # value
        #
        # @return [void]
        def reset_fields
          each_field_name do |key|
            reset_field(key)
          end
        end

        # @param [Array<Symbol>] dont_init
        #   A list of fields not to initialize
        # @return [void]
        private def initialize_fields_default(dont_init = [])
          dont_init = dont_init.map(&:to_sym)
          each_field_name do |k|
            reset_field(k) unless dont_init.include?(k)
          end
        end

        # Callback before fields are initialized by given options
        # and defaults.
        def pre_initialize_fields
        end

        # Callback after fields are initialized.
        def post_initialize_fields
        end

        # Called by the constructor to setup initial fields values
        #
        # @param [Hash<Symbol, Object>] options
        # @return [void]
        def initialize_fields(options = {})
          pre_initialize_fields
          update_fields(options) unless options.empty?
          initialize_fields_default(options.keys)
          post_initialize_fields
        end

        # Sets a field value by key, the value will be coerced
        #
        # @param [Symbol] key
        # @param [Object] value
        # @return [void]
        def field_set(key, value)
          field = self.class.fetch_field(key.to_sym)
          send "#{key}=", field.coerce(value)
        end

        # (see #field_set)
        alias :store :field_set

        # Hard sets a field value by key, the value will bypass validations
        # and coercion.
        # WARNING: Only use this method if you know what you're doing.
        #
        # @param [Symbol] key
        # @param [Object] value
        # @return [void]
        def field_set!(key, value)
          send "_#{key}_set", value
        end

        # Retrieves a field value by key
        #
        # @param [Symbol] key
        # @return [Object]
        def field_get(key)
          self.class.fetch_field(key.to_sym) # ensure that the field exists
          send key
        end

        # Set internal attributes using the hash key~value pairs.
        # These attributes are subject to validation, use #update_fields!
        # instead if validation needs to be bypassed.
        #
        # @param [Hash<Symbol, Object>] opts
        def update_fields(opts)
          opts.each_pair { |k, v| field_set k, v }
          self
        end

        # Sets internal attributes using the Hash key~value pairs.
        # These attributes bypass validation, use #update_fields
        # instead if validation is needed.
        # Only use this method if you know what you're doing.
        #
        # @param [Hash<Symbol, Object>] opts
        def update_fields!(opts)
          opts.each_pair { |k, v| field_set! k, v }
          self
        end

        # Create and return an assoc pair, the first element is the field name
        # and the second if the value of the field.
        #
        # @return [Array[Symbol, Object]] name, value
        def assoc(key)
          [key, field_get(key)]
        end

        # Yields each Field
        #
        # @yieldparam [Symbol] key
        # @yieldparam [Field] field
        #
        # @example
        #   each_field do |key, field|
        #   end
        def each_field(&block)
          return to_enum :each_field unless block_given?
          self.class.each_field.each(&block)
        end

        # Yields each {Field#name}
        #
        # @yieldparam [Symbol] key
        #
        # @example
        #   each_field_name do |key|
        #   end
        def each_field_name
          return to_enum :each_field_name unless block_given?
          each_field do |k, _|
            yield k
          end
        end
        alias :each_key :each_field_name

        # Yields each Field, along with its current value on the Model.
        #
        # @yieldparam [Symbol] key
        # @yieldparam [Field] field
        # @yieldparam [Object] value
        #
        # @example
        #   each_field_with_value do |key, field, value|
        #   end
        def each_field_with_value
          return to_enum :each_field_with_value unless block_given?
          each_field do |k, field|
            yield k, field, field_get(k)
          end
        end

        # Yields each {Field#name} and value
        #
        # @yieldparam [Symbol] key
        # @yieldparam [Objecy] value
        #
        # @example
        #   each_pair do |key, value|
        #   end
        def each_pair
          return to_enum :each_pair unless block_given?
          each_field_with_value do |key, _, value|
            yield key, value
          end
        end

        # Yields each Field's value
        #
        # @yieldparam [Object] value
        #
        # @example
        #   each_value do |value|
        #   end
        def each_value
          return to_enum :each_value unless block_given?
          each_field_with_value do |_, _, value|
            yield value
          end
        end

        # (see #each_pair)
        alias :each :each_pair

        # Should fields be validated?
        # see also {Field#validate}
        #
        # @return [Boolean] by default, this method always returns true
        def validate_fields?
          true
        end

        # Returns a Hash of all the fields key and value
        #
        # @return [Hash<Symbol, Object>]
        def fields_hash
          each_pair.to_h
        end

        # (see #fields_hash)
        alias :fields :fields_hash

        # (see #update_fields)
        def fields=(opts)
          update_fields(opts)
        end

        # Checks if fields are valid, returns false on the first failure.
        #
        # @return [Boolean]
        def valid?
          each_field_with_value do |_, field, value|
            return false unless field.valid?(value)
          end
          true
        end

        # Checks if the model is invalid
        #
        # @return [Boolean]
        def invalid?
          !valid?
        end

        # Runs the validation for each field on the model.
        #
        # @return [self]
        def validate
          each_field_with_value do |key, field, value|
            field.validate(value)
          end
          self
        end

        # Gets a field's value with the provided key
        # This is used to interface with Hash and OpenStruct
        #
        # @param [Symbol] key
        # @return [Object]
        def [](key)
          field_get key
        end

        # Sets a field with the provided key and value
        # This is used to interface with Hash and OpenStruct
        #
        # @param [Symbol] key
        # @param [Object] value
        def []=(key, value)
          field_set key, value
        end
      end
    end
  end
end
