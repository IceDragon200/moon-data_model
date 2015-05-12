module Moon
  module DataModel
    module Fields
      # Methods associated with converting objects to Models
      module ModelCoercion
        # All models are automatically coercable

        # Attempts to convert the provided object to the model
        #
        # @param [Object] obj
        # @return [Object]
        def coerce(obj)
          if obj.is_a?(self)
            obj
          elsif obj.is_a?(Hash)
            new obj
          else
            # TODO, maybe fail here?
            obj
          end
        end
      end
    end
  end
end
