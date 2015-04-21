require 'spec_helper'
require 'data_model/type_validators'

describe Moon::DataModel::TypeValidators::Soft do
  context '.check_type' do
    it 'should validate a simple type' do
      described_class.check_type(String, :test, 'Hello World')
    end

    it 'should validate a composite Array type' do
      described_class.check_type([String], :test, ['Hello World', 'My String'])
    end

    it 'should validate a composite Hash type' do
      described_class.check_type({ String => Integer }, :test, { 'Hello World' => 12, 'My String' => 24 })
    end

    it 'should error on wrong type' do
      expect { described_class.check_type(Integer, :test, 'Oh noes') }.to raise_error(TypeError)
    end
  end
end

describe Moon::DataModel::TypeValidators::Verbose do
  context '.check_type' do
    it 'should validate a simple type' do
      described_class.check_type(String, :test, 'Hello World')
    end

    it 'should validate a composite array type' do
      described_class.check_type([String], :test, ['Hello World', 'My String'])
    end

    it 'should validate a deep nested composite array type' do
      described_class.check_type([[String]], :test, [['Hello World', 'My String'], ['a', 'b']])
    end

    it 'should validate a composite hash type' do
      described_class.check_type({ String => Integer }, :test, { 'Hello World' => 12, 'My String' => 24 })
    end

    it 'should validate a deep nested composite hash type' do
      described_class.check_type({ String => [Integer] }, :test, { 'Hello World' => [12], 'My String' => [24] })
    end

    it 'should error on wrong type' do
      expect { described_class.check_type(Integer, :test, 'Oh noes') }.to raise_error(TypeError)
    end

    it 'should error on wrong composite Array type' do
      expect { described_class.check_type([Integer], :test, [12, 'Oh noes']) }.to raise_error(TypeError)
    end

    it 'should error on wrong composite Hash type' do
      expect { described_class.check_type({ String => Integer }, :test, { 'This' => 12, 'Hello' => 'World' }) }.to raise_error(TypeError)
    end
  end
end

describe Moon::DataModel::TypeValidators::Null do
  context '.check_type' do
    it 'should return true' do
      expect(described_class.check_type(Integer, :test, 1)).to eq(true)
    end
  end
end
