module Fixtures
  # Including Fields directly
  class BasicModel
    include Moon::DataModel::Fields

    field :name, type: String
    field :age,  type: Numeric

    def initialize(opts = {})
      initialize_fields(opts)
    end
  end

  class IdModel < Moon::DataModel::Metal
    field :id, type: String, default: proc { 'GIMME_AN_ID' }
  end

  class ModelWithDefaults < IdModel
    field :a, type: String,  default: ''
    field :b, type: Integer, default: 0
    array :c, type: Object
    dict :d,  key: Object, value: Object
  end

  class ModelTest < IdModel
    field :a, type: String
    field :b, type: Integer
    field :c, type: Array
    field :d, type: Hash
  end

  class SubModelTest < IdModel
    field :name,      type: String
    field :sub_model, type: ModelTest, coerce_values: true
  end

  class Person < Moon::DataModel::Metal
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
    array :pages, type: BookPage
    dict  :meta,  key: String, value: String
  end

  # This model is for testing #to_h, in its complete form
  class DeepNestedModel < Moon::DataModel::Metal
    field :a,              type: String
    array :ary_model,      type: IdModel
    array :ary_hash,       type: Hash
    array :ary_ary,        type: Array
    dict  :hash_model,     key: String, value: IdModel
    dict  :hash_ary,       key: String, value: Array
    dict  :hash_hash,      key: String, value: Hash
  end

  # incomplete Types
  class Blog < Moon::DataModel::Metal
    array :pages, type: 'Fixtures::Page'
  end

  class Page < Moon::DataModel::Metal
    field :blog, type: 'Fixtures::Blog'
  end

  Blog.finalize
  Page.finalize
end
