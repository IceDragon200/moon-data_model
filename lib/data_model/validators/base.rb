require 'data_model/err'

module Moon
  module DataModel
    module Validators
      class Base
        def initialize(options)
          pre_initialize
          initialize_options(options)
          post_initialize
        end

        def pre_initialize
        end

        def initialize_options(options = {})
        end

        def post_initialize
        end

        # @param [Object] value  object to validate
        # @return [Boolean]
        def valid?(value)
          true
        end

        # @param [Object] value  object to validate
        def validate(value)
          raise ValidationFailed unless valid?(value)
        end

        def self.register(key)
          @registered = key
          Validators.register key, self
        end
      end
    end
  end
end
