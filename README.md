Moon Data Model
===============
This was extracted from Moon's data_model package.

## Usage:
If you are using DataModel as a rubygem, then you must use active_support, to
get inflections, otherwise, moon has std/inflector (which is a copy of active_support's inflector).

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
