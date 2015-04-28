require 'data_model/type_validators/soft'
require 'data_model/validators/base'

module Moon
  module DataModel
    module Validators
      class Type < Base
        class << self
          attr_accessor :default
        end

        self.default ||= Moon::DataModel::TypeValidators::Soft

        def initialize_options(options)
          super
          @type = options.fetch(:type)
          @validator = options.fetch(:validator, self.class.default)
        end

        def post_init
          @validator.ensure_type @type
        end

        def valid?(value)
          @validator.check_type(@type, value, quiet: true)
        end

        def validate(value)
          @validator.check_type(@type, value)
        end

        register :type
      end
    end
  end
end
