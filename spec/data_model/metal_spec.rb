require 'spec_helper'
require 'data_model/load'

describe Moon::DataModel::Metal do
  context '.fields' do
    it 'should have correct fields' do
      id_field = Fixtures::MetalTest.fetch_field(:id)
      expect(id_field.type).to eq(Moon::DataModel::Type[String])
    end
  end

  context '.fetch_field' do
    it 'should fetch an existing field' do
      field = Fixtures::ModelTest.fetch_field(:a)
      expect(field.name).to eq(:a)
      expect(field.type).to equal(Moon::DataModel::Type[String])
    end
  end

  context '#initialize' do
    it 'should initialize and set default fields' do
      obj = Fixtures::MetalTest.new
      expect(obj.id).to eq('GIMME_AN_ID')
    end

    it 'should initialize given a hash' do
      obj = Fixtures::MetalTest.new(id: '123abc')
      expect(obj.id).to eq('123abc')
    end

    it 'should initialize sub models from hashes' do
      obj = Fixtures::SubModelTest.new(name: 'Awesome', metal: { id: 'ABC123' })
      expect(obj.name).to eq('Awesome')
      expect(obj.metal.id).to eq('ABC123')
    end
  end
end
