require 'spec_helper'
require 'std/core_ext/array'
require 'std/inflector'
require 'std/inflector/core_ext/string'
require 'std/mixins/prototype'
require 'std/mixins/serializable'
require 'data_model/load'

module Fixtures
  class Person
    include Moon::DataModel::Fields

    field :name, type: String
    field :age,  type: Numeric
  end
end

describe Fixtures::Person do
  subject(:person) { described_class.new(name: 'Henry', age: 26) }

  context '.each_field' do
    it 'should iterate each field on the class' do
      result = []
      described_class.each_field do |key, field|
        result << [key, field]
      end
      expect(result.map(&:first)).to eq([:name, :age])
    end
  end
end
