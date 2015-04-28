module Moon
  module DataModel
    # Error raised when trying to create a {Type} from an object not typeable
    # EG. nil
    class InvalidModelType < TypeError
    end

    # Error raised when an incomplete type is used
    class IncompleteType < RuntimeError
    end

    # Generic {Field} error
    class FieldError < RuntimeError
    end

    # Raised by {Fields::Modelling#fetch_field} when the field is not found
    class FieldNotFound < FieldError
    end

    # Error raised by {TypeValidators} when a {Type#model} cannot be checked.
    class InvalidType < TypeError
    end

    # Error raised when a value fails validation
    class TypeValidationError < TypeError
    end

    # Generic validation error raised by {Validators}
    class ValidationFailed < StandardError
    end
  end
end
