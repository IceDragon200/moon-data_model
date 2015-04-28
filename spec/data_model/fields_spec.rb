require 'spec_helper'
require 'std/core_ext/array'
require 'std/inflector'
require 'std/inflector/core_ext/string'
require 'std/mixins/prototype'
require 'std/mixins/serializable'
require 'data_model/load'

describe Moon::DataModel::Fields do
  subject(:person) { Fixtures::Person.new(name: 'Henry', age: 26) }

  context '.each_field' do
    it 'should iterate each field on the class' do
      result = []
      Fixtures::Person.each_field do |key, field|
        result << [key, field]
      end
      expect(result.map(&:first)).to eq([:name, :age])
    end
  end
end
