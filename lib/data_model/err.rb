module Moon
  module DataModel
    class InvalidModelType < TypeError
    end

    class IncompleteType < RuntimeError
    end

    class FieldError < RuntimeError
    end

    class FieldNotFound < FieldError
    end

    class InvalidType < TypeError
    end

    class TypeValidationError < TypeError
    end

    class ValidationFailed < StandardError
    end
  end
end
