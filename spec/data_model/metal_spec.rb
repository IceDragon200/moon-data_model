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
    it 'should convert the model to a Hash' do
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
  end
end
