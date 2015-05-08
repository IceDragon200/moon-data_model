Moon Data Model
===============
[![Build Status](https://travis-ci.org/polyfox/moon-data_model.svg?branch=master)](https://travis-ci.org/polyfox/moon-data_model)
[![Test Coverage](https://codeclimate.com/github/polyfox/moon-data_model/badges/coverage.svg)](https://codeclimate.com/github/polyfox/moon-data_model)
[![Inline docs](http://inch-ci.org/github/polyfox/moon-data_model.svg?branch=master)](http://inch-ci.org/github/polyfox/moon-data_model)
[![Code Climate](https://codeclimate.com/github/polyfox/moon-data_model/badges/gpa.svg)](https://codeclimate.com/github/polyfox/moon-data_model)

This was extracted from Moon's data_model package.

## Usage:
```ruby
# You can use the Fields, in your own objects
class MyAwesomeModel
  include Moon::DataModel::Fields

  field :id,   type: String, default: proc { "GIMME_AN_ID" }
  field :name, type: String

  def initialize(options = {})
    # you can then initialize the fields using
    initialize_fields(options )
  end
end

model = MyAwesomeModel.new name: 'Albert' 
model.id   #=> GIMME_AN_ID
model.name #=> Albert

model = MyAwesomeModel.new id: 'ABCD1234', name: 'Simon'
model.id   #=> ABCD1234
model.name #=> Simon


# Or you can just grab one of the existing base classes
class MyAwesomeModel < Moon::DataModel::Metal
  field :id,   type: String, default: proc { "GIMME_AN_ID" }
  field :name, type: String
end

# Did we mention that you also get all fields from your parent class :3
class MyAwesomeModelOfDoom < Moon::DataModel::Base
end

m = MyAwesomeModelOfDoom.new
m.id  # => ABCDEF1234567890
m.name # => ''
m.meta # => {}
m.note # => ''
m.tags # => []
```

## Note:
If you are using DataModel as a rubygem, then you must use active_support, to
get inflections, otherwise, use [moon-inflector](https://github.com/polyfox/moon-inflector).

## Validators:
Unless you require DataModel via `data_model/load`,
Be sure to set a TypeValidator before using it:
```ruby
# soft validator
Moon::DataModel::Validators::Type.default = Moon::DataModel::TypeValidators::Soft

# verbose validator
Moon::DataModel::Validators::Type.default = Moon::DataModel::TypeValidators::Verbose

# null validator
Moon::DataModel::Validators::Type.default = Moon::DataModel::TypeValidators::Null
```
