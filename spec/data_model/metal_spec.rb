require 'spec_helper'
require 'data_model/metal'

describe Moon::DataModel::Metal do
  context '#initialize' do
    it 'should initialize and set default fields' do
      obj = Fixtures::IdModel.new
      expect(obj.id).to eq('GIMME_AN_ID')
    end

    it 'should initialize given a hash' do
      obj = Fixtures::IdModel.new(id: '123abc')
      expect(obj.id).to eq('123abc')
    end

    it 'should initialize sub models from hashes' do
      obj = Fixtures::SubModelTest.new(
        name: 'Awesome',
        sub_model: {
          id: 'ABC123',
          a: 'Hello World',
          b: 1,
          c: [],
          d: {}
        }
      )
      expect(obj.name).to eq('Awesome')
      expect(obj.sub_model.id).to eq('ABC123')
      expect(obj.sub_model.a).to eq('Hello World')
      expect(obj.sub_model.b).to eq(1)
      expect(obj.sub_model.c).to eq([])
      expect(obj.sub_model.d).to eq({})
    end
  end

  context '#to_h' do
    it 'should convert the model to a Hash (basic)' do
      obj = Fixtures::Book.new(
        name: 'Stupid Multi Core tricks',
        pages: [Fixtures::BookPage.new(num: 1)],
        meta: { "is_awesome_book" => "9/11, IGN"}
      )

      actual = obj.to_h

      expect(actual).to eq({
        name: 'Stupid Multi Core tricks',
        pages: [{ num: 1 }],
        meta: { "is_awesome_book"=>"9/11, IGN" }
      })
    end

    it 'should convert a complex nestedt model to a Hash' do
      data = {
        a: 'A',
        ary_model: [{ id: 'ABC123' }, { id: 'DEF456' }],
        ary_hash: [{ a: 1, b: 2 }, { c: 3, d: 4 }],
        ary_ary: [[1, 2], [3, 4]],
        hash_model: { "ABC123" => { id: '1' }, "DEF456" => { id: '2' } },
        hash_ary: { "ABC123" => [1, 2, 3], "DEF456" => [4, 5, 6] },
        hash_hash: { "ABC123" => { a: 1, b: 2 }, "DEF456" => { c: 3, d: 4 } }
      }
      model = Fixtures::DeepNestedModel.new(data)
      expect(model.to_h).to eq(data)
    end

    # this is to test for a bug, where fields with nil as their default,
    # would be converted to an empty hash instead of nil
    it 'should convert a model with nil default fields' do
      data = {
        name: nil,
        date: nil,
        blah: nil
      }
      model = Fixtures::ModelWithNilDefaults.new
      expect(model.to_h).to eq(data)
    end
  end
end
