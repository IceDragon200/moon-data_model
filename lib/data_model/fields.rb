require 'std/mixins/serializable'
require 'std/mixins/prototype'
require 'data_model/err'
require 'data_model/field'

module Moon
  module DataModel
    module Fields
      # Patches the provided options hash.
      #
      # @param [Hash] options
      # @return [Hash] same one given
      def self.adjust_field_options(klass, options)
        # set the class default settings
        klass.each_field_setting do |key, value|
          options[key] = value
        end

        # if the default value is set to nil, and allow_nil hasn't already
        # been set, then the field is allowed to be nil.
        if options.key?(:default) && options[:default].nil?
          options[:allow_nil] = true unless options.key?(:allow_nil)
        end

        # if default value was not set, but the field allows nil,
        # then the default value is nil
        if !options.key?(:default) && options[:allow_nil]
          options[:default] = nil
        end

        # if no type was given, assume it allows anything, therefore Object
        unless options.key?(:type)
          options[:type] = ::Object
        end

        options
      end

      module Modelling
        include Serializable::Properties::ClassMethods

        prototype_attr :field, default: proc { {} }
        prototype_attr :field_setting, default: proc { {} }

        # Finalizes incomplete fields, see {Field#finalize}
        #
        # @return [void]
        def finalize
          fields.each do |_, field|
            field.finalize
          end
        end

        # Locates a field by name
        #
        # @param [Symbol] expected_key  expected field name
        # @yieldparam [Symbol] key name
        # @return [Field, nil] returns the field for the corresponding key,
        #                      or nil if the key was not found.
        def find_field(expected_key = nil, &block)
          if block_given?
            each_field do |key, field|
              return field if block.call(key)
            end
          else
            each_field do |key, field|
              return field if expected_key == key
            end
          end
          nil
        end

        # Locates a field by name, if teh field is not found a FieldNotFound
        # is raised.
        # (see #find_field)
        #
        # @return [Field]
        def fetch_field(expected_key = nil, &block)
          find_field(expected_key, &block) ||
            (raise FieldNotFound, "could not find field #{key}.")
        end

        # Field settings are common parameters amongst fields,
        # it can be used to setup mulitple fields with the same parameters.
        # Anyway setting/options that can be used on a field line can be
        # used as a setting.
        #
        # @overload field_setting(key)
        #   Retrives field_setting value by key
        #   @param [Symbol] key
        #   @return [Object] value at key
        #
        #   @example Basic usage
        #     field_setting :default
        #
        # @overload field_setting(key, value)
        #   Sets a field_setting value by key
        #   @param [Symbol] key
        #   @param [Object] value
        #   @return [void]
        #
        #   @example Basic usage
        #     field_setting :default, proc { |type| type.model.new }
        #
        # @overload field_setting(options)
        #   Merges the options into the field settings
        #   @param [Hash] options
        #   @return [void]
        #
        #   @example Basic usage
        #     field_setting type: String
        #
        # A block can be passed in to temporarily use the field_settings within
        # the blocks context.
        # @example
        #   field_setting type: String do
        #     # all fields declared here will have the type String
        #     field :id
        #     field :name
        #     field :secret
        #   end
        def field_setting(obj, *args)
          # allows you to temporarily apply the field_settings to the block.
          if block_given?
            org = field_settings.dup
            field_setting(obj, *args)
            yield self
            field_settings.clear
            field_setting org
          else
            if Hash === obj
              field_settings.merge!(obj)
            else
              if args.size > 0
                field_settings[obj] = args.singularize
              else
                field_settings[obj]
              end
            end
          end
        end

        # @param [Field] field
        # @param [Symbol] name
        #
        # @api private
        private def define_field_writer(field, name)
          setter = "_#{name}_set"
          alias_method setter, "#{name}="
          define_method "#{name}=" do |obj|
            field.validate(obj) if validate_fields?
            send setter, obj
          end
        end

        # Define a new field, without option adjustments
        #
        # @param [Symbol] name
        # @param [Hash] options
        #
        # @api private
        private def add_field(name, options)
          field = fields[name.to_sym] = Field.new(options.merge(name: name.to_sym))

          # first setup the Serializable property, this also creates the
          # initial attr for us
          property_accessor name
          # next we'll need to overwrite the writer created by property_accessor,
          # with our field validation one.
          define_field_writer field, name

          name.to_sym
        end

        # Define a new field
        #
        # @param [Symbol] name
        # @param [Hash] options
        # @return [Symbol]
        def field(name, options = {})
          add_field name, Fields.adjust_field_options(self, options)
        end

        # Defines a new Array field, is a shorthand for field type: [Type]
        #
        # @return [Symbol]
        def array(sym, options)
          size = options.delete(:size) || 0
          default = (options[:default] || proc{ Array.new(size) })
          type = Array[options.fetch(:type)]
          field sym, options.merge(type: type, default: default)
        end

        # Defines a new Hash field, is a shorthand for field type: {Type=>Type}
        #
        # @return [Symbol]
        def dict(sym, options)
          default = (options[:default] || proc{ Hash.new })
          type = Hash[options.fetch(:key)=>options.fetch(:value)]
          field sym, options.merge(type: type, default: default)
        end
      end

      module ModelCoercion
        # All models are automatically coercable

        # Attempts to convert the provided object to the model
        #
        # @param [Object] obj
        # @return [Object]
        def coerce(obj)
          if obj.is_a?(self)
            obj
          elsif obj.is_a?(Hash)
            new obj
          else
            # TODO, maybe fail here?
            obj
          end
        end
      end

      module ClassMethods
        include Modelling
        include ModelCoercion
      end

      module InstanceMethods
        include Serializable::Properties::InstanceMethods
        # this allows Fields to behave like Hashes :)
        include Enumerable

        ##
        # @param [Symbol] key
        private def reset_field(key)
          field = self.class.fetch_field(key)
          field_set key, field.make_default(self)
        end

        ##
        # Initializes all available fields for the model
        private def reset_fields
          each_field_name do |key|
            reset_field(key)
          end
        end

        # @param [Array<Symbol>] dont_init
        #   A list of fields not to initialize
        private def initialize_fields_default(dont_init = [])
          each_field_name do |k|
            next if dont_init.any? { |s| s.to_s == k.to_s }
            reset_field(k)
          end
        end

        # Callback before fields are initialized by given options
        # and defaults
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
          update_fields(options)
          initialize_fields_default(options.keys)
          post_initialize_fields
        end

        # @param [Symbol] key
        # @param [Object] value
        # @return [void]
        def field_set(key, value)
          field = self.class.fetch_field(key.to_sym)
          send "#{key}=", field.coerce(value)
        end

        # @param [Symbol] key
        # @param [Object] value
        # @return [void]
        def field_set!(key, value)
          send "_#{key}_set", value
        end

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

        # @return [Array[Symbol, Object]]
        def assoc(key)
          [key, field_get(key)]
        end

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
        def each(&block)
          each_pair(&block)
        end

        # @return [Boolean]
        def validate_fields?
          true
        end

        # @return [Hash<Symbol, Object>]
        def fields_hash
          each_field_name.each_with_object({}) { |p, r| r[p[0]] = p[1] }
        end

        # @return [Hash<Symbol, Object>]
        def fields
          fields_hash
        end

        # @param [Hash<Symbol, Object>] options
        def fields=(options)
          update_fields(options)
        end

        # Runs the validation for each field on the model.
        #
        # @return [self]
        def validate
          each_field do |key, field|
            field.check_type(key, field_get(key))
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

      include InstanceMethods

      # @param [Module] mod
      def self.included(mod)
        mod.extend         ClassMethods
      end
    end
  end
end
