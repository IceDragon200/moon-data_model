require 'spec_helper'
require 'data_model/load'

module Fixtures
  class MetalTest < Moon::DataModel::Metal
    field :id, type: String, default: proc { 'GIMME_AN_ID' }
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
