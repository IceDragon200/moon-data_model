Moon Data Model
===============
This was extracted from Moon's data_model package.


## Validators:
Unless you require DataModel via `data_model/load`,
Be sure to set a TypeValidator before using it:
```ruby
# soft validator
Moon::DataModel::Field.type_validator = Moon::DataModel::TypeValidators::Soft

# verbose validator
Moon::DataModel::Field.type_validator = Moon::DataModel::TypeValidators::Verbose

# null validator
Moon::DataModel::Field.type_validator = Moon::DataModel::TypeValidators::Null
```
