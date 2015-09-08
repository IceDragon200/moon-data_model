require 'data_model/fields/class_methods'
require 'data_model/fields/instance_methods'

module Moon
  module DataModel
    # The backbone of DataModel's overall system
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

        unless (obj = options[:default]).is_a?(Proc)
          options[:default] = ->(_, _) { obj.maybe_dup }
        end

        options
      end

      include InstanceMethods

      # @param [Module] mod
      def self.included(mod)
        mod.extend         ClassMethods
      end
    end
  end
end
