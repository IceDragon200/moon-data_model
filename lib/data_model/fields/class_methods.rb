require 'data_model/fields/modelling'
require 'data_model/fields/model_coercion'

module Moon
  module DataModel
    module Fields
      # All class methods for {Fields}
      module ClassMethods
        include Modelling
        include ModelCoercion
      end
    end
  end
end
