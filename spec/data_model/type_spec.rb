require 'spec_helper'
require 'data_model/type'

describe Moon::DataModel::Type do
  it 'should fail to create a nil type' do
    # use NilClass instead
    expect { described_class[nil] }.to raise_error()
  end

  it 'should create an incomplete type' do
    t = described_class['Array']
    expect(t).to be_incomplete

    t.finalize
    expect(t).not_to be_incomplete
  end

  it 'should create a Type object' do
    int = described_class[Integer]
    ary = described_class[Array]
    hsh = described_class[Hash]
    hsh_str_str = described_class[Hash[String => String]]
    ary_str = described_class[Array[String]]

    expect(int).to be_kind_of(Moon::DataModel::Type)
    expect(int.model).to equal(Integer)

    expect(ary).to be_kind_of(Moon::DataModel::Type)
    expect(ary.model).to equal(Array)
    expect(ary.content).to equal(nil)
    expect(ary).to be_array

    expect(hsh).to be_kind_of(Moon::DataModel::Type)
    expect(hsh.model).to equal(Hash)
    expect(hsh.content).to equal(nil)
    expect(hsh).to be_hash

    expect(hsh_str_str).to be_kind_of(Moon::DataModel::Type)
    expect(hsh_str_str.model).to equal(Hash)
    expect(hsh_str_str.content).to eq({String=>String})
    expect(hsh_str_str).to be_hash

    expect(ary_str).to be_kind_of(Moon::DataModel::Type)
    expect(ary_str.model).to equal(Array)
    expect(ary_str.content).to eq([String])
    expect(ary_str).to be_array
  end

  it 'should initialize singleton of a simple type' do
    a1 = described_class[Array]
    a2 = described_class[Array]

    expect(a1).to be_equal(a2)
  end

  it 'should initialize singleton of a complex type' do
    a1 = described_class[Array[Array[String]]]
    a2 = described_class[Array[Array[String]]]

    expect(a1).to be_equal(a2)
  end

  it 'should coerce a type' do
    a = described_class[Array]
    actual = a.coerce(1)
    expect(actual).to eq([1])

    a1 = described_class[Array[String]]
    actual = a1.coerce(['1', '2', '3'])
    expect(actual).to eq(['1', '2', '3'])

    h = described_class[Hash]
    actual = h.coerce([[:a, 1]])
    expect(actual).to eq(a: 1)

    h1 = described_class[Hash[Symbol => Integer]]
    actual = h1.coerce(a: 1, b: 2)
    expect(actual).to eq(a: 1, b: 2)

    m = described_class[Fixtures::ModelTest]
    actual = m.coerce(a: 'Hello World', b: 'How are you', c: 3)
    expect(actual).to be_kind_of(Fixtures::ModelTest)
    expect(actual.a).to eq('Hello World')
    expect(actual.b).to eq('How are you')
    expect(actual.c).to eq(3)
  end
end
