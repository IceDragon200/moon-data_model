require 'moon-serializable/load'
require 'data_model/fields'

module Moon
  module DataModel
    # Base module for including into your objects.
    #
    # Check {Fields} for methods included by {Model}
    module Model
      # @param [Module] mod
      def self.included(mod)
        mod.send :include, Fields
        mod.send :include, Moon::Serializable
      end
    end
  end
end
