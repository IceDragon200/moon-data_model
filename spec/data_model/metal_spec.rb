require 'spec_helper'
require 'data_model/load'

describe Moon::DataModel::Metal do
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

  context '#to_h' do
    it 'should convert the model to a Hash' do
      obj = Fixtures::Book.new(
        name: 'Stupid Multi Core tricks',
        pages: [Fixtures::BookPage.new(num: 1)],
        meta: { "is_awesome_book" => "9/11, IGN"}
      )
      actual = obj.to_h
      expect(actual).to be_instance_of(Hash)
      expect(actual).to eq({
        name: 'Stupid Multi Core tricks',
        pages: [{ num: 1 }],
        meta: { "is_awesome_book"=>"9/11, IGN" }
      })
    end
  end
end
