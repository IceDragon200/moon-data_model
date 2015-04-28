require 'spec_helper'
require 'data_model/field'

describe Moon::DataModel::Field do
  it 'should create a new field' do
    f = described_class.new(name: :test, type: Object)
    expect(f.name).to eq(:test)
    expect(f.allow_nil).to eq(false)
    expect(f.default).to eq(nil)
    expect(f.is_key).to eq(false)
    expect(f.type).to equal(Moon::DataModel::Type[Object])
  end

  context '.default_proc' do
    it 'should initialize an Array type' do
      t = Moon::DataModel::Type[Array]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(Array)
    end

    it 'should initialize a Hash type' do
      t = Moon::DataModel::Type[Hash]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(Hash)
    end

    it 'should initialize a Float type' do
      t = Moon::DataModel::Type[Float]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(Float)
    end

    it 'should initialize an Integer type' do
      t = Moon::DataModel::Type[Integer]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(Integer)
    end

    it 'should initialize a Numeric type' do
      t = Moon::DataModel::Type[Numeric]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(Numeric)
    end

    it 'should initialize everything else using .new' do
      t = Moon::DataModel::Type[String]
      actual = described_class.default_proc.call(t, nil)
      expect(actual).to be_kind_of(String)
    end
  end
end
