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
end
