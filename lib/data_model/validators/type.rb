require 'data_model/type_validators/soft'
require 'data_model/validators/base'

module Moon
  module DataModel
    module Validators
      # Ensures that the provided value is the Type required, usually
      # appended first to a validators stack.
      # see {Field#validators}
      class Type < Base
        class << self
          # @!attribute default
          #   @return [Moon::DataModel::TypeValidators::Base]
          #     default validator to be used for Type validations.
          attr_accessor :default
        end

        self.default ||= Moon::DataModel::TypeValidators::Verbose

        # @param [Hash] options
        # @option options [Type] :type
        # @option options [TypeValidators::Base<>] :validator
        # @api private
        def initialize_options(options)
          super
          @type = options.fetch(:type)
          @allow_nil = options.fetch(:allow_nil, false)
          @validator = options.fetch(:validator, self.class.default)
        end

        # @api private
        def post_initialize
          # TODO, find some way of asserting classes
          @validator.send :ensure_obj_is_a_type, @type
        end

        # (see Base#test_valid)
        def test_valid(value)
          @validator.check_type(@type, value,
            quiet: true, allow_nil: @allow_nil, ctx: @ctx)
        end

        register :type
      end
    end
  end
end
