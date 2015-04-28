require 'spec_helper'
require 'std/core_ext/array'
require 'std/inflector'
require 'std/inflector/core_ext/string'
require 'std/mixins/prototype'
require 'std/mixins/serializable'
require 'data_model/load'

describe Moon::DataModel::Fields do
  subject(:person) { Fixtures::Person.new(name: 'Henry', age: 26) }

  context '.fields' do
    it 'should have correct fields' do
      id_field = Fixtures::MetalTest.fetch_field(:id)
      expect(id_field.type).to eq(Moon::DataModel::Type[String])
    end
  end

  context '.each_field' do
    it 'should iterate each field on the class' do
      result = []
      Fixtures::Person.each_field do |key, field|
        result << [key, field]
      end
      expect(result.map(&:first)).to eq([:name, :age])
    end
  end

  context '.find_field' do
    it 'should locate a field by key' do
      actual = Fixtures::Person.find_field(:name)
      expect(actual).to be_kind_of(Moon::DataModel::Field)
      expect(actual.name).to eq(:name)
    end

    it 'should locate a field by block' do
      actual = Fixtures::Person.find_field { |_, field| field.name == :age }
      expect(actual).to be_kind_of(Moon::DataModel::Field)
      expect(actual.name).to eq(:age)
    end
  end

  context '.fetch_field' do
    it 'should fetch an existing field' do
      field = Fixtures::ModelTest.fetch_field(:a)
      expect(field.name).to eq(:a)
      expect(field.type).to equal(Moon::DataModel::Type[String])
    end

    it 'should fail with FieldNotFound if teh field doesn\'t exist' do
      expect { Fixtures::Person.fetch_field(:egg) }.to raise_error(Moon::DataModel::FieldNotFound)
    end
  end


  context '#reset_fields' do
    it 'should reset fields on a model' do
      obj = Fixtures::MetalTest.new(id: '123abc')
      expect(obj.id).to eq('123abc')
      obj.reset_fields
      expect(obj.id).to eq('GIMME_AN_ID')
    end
  end

  context '#field_set!' do
    it 'should set a field bypassing its validations' do
      obj = Fixtures::MetalTest.new(id: '123abc')
      obj.field_set!(:id, 1)
      expect(obj.id).to eq(1)
      expect(obj).not_to be_valid

      expect { obj.validate }.to raise_error(Moon::DataModel::ValidationFailed)
    end
  end
end
