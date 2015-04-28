require 'std/mixins/serializable'
require 'data_model/fields'

module Moon
  module DataModel
    module Model
      # @param [Module] mod
      def self.included(mod)
        mod.send :include, Fields
        mod.send :include, Moon::Serializable
      end
    end
  end
end
