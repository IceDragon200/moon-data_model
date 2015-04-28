require 'data_model/type_validators/base'

module Moon
  module DataModel
    module TypeValidators
      module Null
        include Moon::DataModel::TypeValidators::Base

        def do_check(type, value, options = {})
          true
        end

        extend self
      end
    end
  end
end
