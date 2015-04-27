require 'spec_helper'
require 'data_model/load'

module Fixtures
  class MetalTest < Moon::DataModel::Metal
    field :id, type: String, default: proc { 'GIMME_AN_ID' }
  end

  class SubModelTest < Moon::DataModel::Metal
    field :name, type: String
    field :metal, type: MetalTest
  end
end

describe Fixtures::MetalTest do
  context '#initialize' do
    it 'should initialize and set default fields' do
      obj = described_class.new
      expect(obj.id).to eq('GIMME_AN_ID')
    end

    it 'should initialize given a hash' do
      obj = described_class.new(id: '123abc')
      expect(obj.id).to eq('123abc')
    end
  end
end

describe Fixtures::SubModelTest do
  context '#initialize' do
    it 'should initialize sub models from hashes' do
      obj = described_class.new(name: 'Awesome', metal: { id: 'ABC123' })
      expect(obj.name).to eq('Awesome')
      expect(obj.metal.id).to eq('ABC123')
    end
  end
end
