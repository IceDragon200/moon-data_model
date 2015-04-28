require 'data_model/err'

module Moon
  module DataModel
    module Validators
      class Base
        def initialize(options)
          pre_init
          initialize_options(options)
          post_init
        end

        def pre_init
        end

        def initialize_options(options = {})
        end

        def post_init
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
