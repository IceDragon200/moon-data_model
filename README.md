Moon Data Model
===============
[![Build Status](https://travis-ci.org/IceDragon200/moon-data_model.svg?branch=master)](https://travis-ci.org/IceDragon200/moon-data_model)
[![Test Coverage](https://codeclimate.com/github/IceDragon200/moon-data_model/badges/coverage.svg)](https://codeclimate.com/github/IceDragon200/moon-data_model)
[![Inline docs](http://inch-ci.org/github/IceDragon200/moon-data_model.svg?branch=master)](http://inch-ci.org/github/IceDragon200/moon-data_model)
[![Code Climate](https://codeclimate.com/github/IceDragon200/moon-data_model/badges/gpa.svg)](https://codeclimate.com/github/IceDragon200/moon-data_model)
This was extracted from Moon's data_model package.

## Usage:
If you are using DataModel as a rubygem, then you must use active_support, to
get inflections, otherwise, moon has std/inflector (which is a copy of active_support's inflector).

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
