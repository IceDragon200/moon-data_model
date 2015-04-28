Encoding.default_internal = Encoding.default_external = 'UTF-8'

require 'codeclimate-test-reporter'
require 'simplecov'
require 'moon/packages'
require 'active_support/core_ext/string'

CodeClimate::TestReporter.start
SimpleCov.start

require 'data_model/load'

module Fixtures
  class Person
    include Moon::DataModel::Fields

    field :name, type: String
    field :age,  type: Numeric

    def initialize(opts = {})
      initialize_fields(opts)
    end
  end

  class ModelTest < Moon::DataModel::Metal
    field :a, type: String
    field :b, type: String
    field :c, type: Integer
  end

  class MetalTest < Moon::DataModel::Metal
    field :id, type: String, default: proc { 'GIMME_AN_ID' }
  end

  class SubModelTest < Moon::DataModel::Metal
    field :name, type: String
    field :metal, type: MetalTest
  end

  class Blog < Moon::DataModel::Metal
    array :pages, type: 'Fixtures::Page'
  end

  class Page < Moon::DataModel::Metal
    field :blog, type: 'Fixtures::Blog'
  end

  Blog.finalize
  Page.finalize

  class StringModel < Moon::DataModel::Metal
    field_setting type: String do
      fail unless field_setting(:type) == String
      field :first_name
      field :middle_name, default: nil
      field :last_name, allow_nil: true
    end

    field_setting :default, Moon::DataModel::Field.default_proc

    field :extras

    field_settings.delete(:default)
  end

  class BookPage < Moon::DataModel::Metal
    field :num, type: Integer
  end

  class Book < Moon::DataModel::Metal
    field :name,  type: String
    array :pages, type: Page
    dict  :meta,   key: String, value: String
  end
end
