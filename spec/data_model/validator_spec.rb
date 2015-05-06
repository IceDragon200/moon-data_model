require 'spec_helper'
require 'data_model/validators'

describe Moon::DataModel::Validators do
  context '.entries' do
    it 'returns the registry' do
      expect(described_class.entries).to be_instance_of(Hash)
    end
  end

  context '.fetch' do
    it 'fails if the validator by key doesn\'t exist' do
      expect { described_class.fetch(:stupidity_checker) }.to raise_error(KeyError)
    end
  end

  context ':longer_than3' do
    it 'is registered' do
      expect(described_class.registered?(:longer_than3)).to eq(true)
    end

    it 'should fail if the value is too short' do
      expect { Fixtures::L3Model.new(name: 'zx') }.to raise_error(Moon::DataModel::ValidationFailed)
    end
  end
end
