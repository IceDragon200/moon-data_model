require 'data_model/type_validators/base'

module Moon
  module DataModel
    module TypeValidators
      # A TypeValidator which will skip all checks, only use this if you
      # know what you're doing.
      module Null
        include Moon::DataModel::TypeValidators::Base

        # @param [Type] type
        # @param [Object] value
        # @param [Hash] options
        # @return [Boolean]
        protected def do_check(type, value, options = {})
          true
        end

        extend self
      end
    end
  end
end
