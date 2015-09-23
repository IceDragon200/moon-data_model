require 'moon-serializable/load'
require 'moon-prototype/load'
require 'moon-maybe_copy/load'
require 'data_model/err'
require 'data_model/field'

module Moon
  module DataModel
    module Fields
      # Methods for setting up, and finding fields on a Model class.
      module Modelling
        extend Moon::Prototype
        include Serializable::Properties::ClassMethods

        prototype_attr :field,         type: Hash
        prototype_attr :field_setting, type: Hash

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
              return field if block.call(key, field)
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
            (raise FieldNotFound,
              "no such field `#{expected_key}` for #{self}.")
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
        # the block's context.
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
                field_settings[obj] = args.first
              else
                field_settings[obj]
              end
            end
          end
        end

        # @param [Field] field
        # @param [Symbol] name
        # @return [Symbol]
        #
        # @api private
        private def define_field_writer(field, name)
          setter = "_#{name}_set".to_sym
          alias_method setter, "#{name}=".to_sym
          define_method "#{name}=".to_sym do |obj|
            field.validate(obj) if validate_fields?
            send setter, obj
          end
        end

        # Registers and creates accessors for a given field
        #
        # @param [Field] field
        # @return [Symbol] field name
        # @return [Symbol]
        #
        # @api public
        def add_field(field)
          fields[field.name] = field

          # first setup the Serializable property, this also creates the
          # initial attr for us
          property_accessor field.name
          # next we'll need to overwrite the writer created by property_accessor,
          # with our field validation one.
          define_field_writer field, field.name

          field.name
        end

        # Defines a new, without option adjustments
        #
        # @param [Symbol] name
        # @param [Hash] options
        # @return [Symbol]
        #
        # @api public
        def define_field(name, options)
          add_field Field.new(options.merge(name: name.to_sym))
        end

        # Defines a new field with option adjustments
        #
        # @param [Symbol] name
        # @param [Hash] options
        # @return [Symbol]
        def field(name, options = {})
          define_field name, Fields.adjust_field_options(self, options)
        end

        # Defines a new Array field, is a shorthand for field type: [Type]
        #
        # @param [Symbol] sym
        # @param [Hash<Symbol, Object>] options
        # @option options [Integer] :size  default: 0
        # @option options [Proc, Object] :default
        # @option options [Module] :type  content type of the Array
        # @return [Symbol]
        def array(sym, options)
          size = options.fetch(:size, 0)
          default = options.fetch(:default) { ->(_, _) { Array.new(size) } }
          type = Array[options.fetch(:type)]
          field sym, options.merge(type: type, default: default)
        end

        # Defines a new Hash field, is a shorthand for field type: {Type=>Type}
        #
        # @param [Symbol] sym
        # @param [Hash<Symbol, Object>] options
        # @option options [Proc, Object] :default
        # @option options [Module] :key  key type
        # @option options [Module] :value  value type
        # @return [Symbol]
        def dict(sym, options)
          default = options.fetch(:default) { ->(_, _) { Hash.new } }
          type = Hash[options.fetch(:key) => options.fetch(:value)]
          field sym, options.merge(type: type, default: default)
        end
      end
    end
  end
end
