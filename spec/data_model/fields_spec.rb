require 'spec_helper'
require 'data_model/fields'

describe Moon::DataModel::Fields do
  subject(:basic_model) { Fixtures::BasicModel.new(name: 'Henry', age: 26) }

  context 'ClassMethods' do
    context '.field' do
      it 'should allow nil values if allow_nil is true' do
        person = Fixtures::Person.new(first_name: 'Henry', last_name: nil)
      end
    end

    context '.fields' do
      it 'returns a list of fields for the model (only for the current class)' do
        actual = Fixtures::ModelTest.fields
        expect(actual.keys).to eq([:a, :b, :c, :d])
      end
    end

    context '.all_fields' do
      it 'returns a list of all fields for the model' do
        actual = Fixtures::ModelTest.all_fields
        expect(actual.keys).to eq([:id, :a, :b, :c, :d])
      end
    end

    context '.each_field' do
      it 'should iterate each field on the class' do
        result = []
        Fixtures::BasicModel.each_field do |key, field|
          result << [key, field]
        end
        expect(result.map(&:first)).to eq([:name, :age])
      end
    end

    context '.find_field' do
      it 'should locate a field by key' do
        actual = Fixtures::BasicModel.find_field(:name)
        expect(actual).to be_kind_of(Moon::DataModel::Field)
        expect(actual.name).to eq(:name)
      end

      it 'should locate a field by block' do
        actual = Fixtures::BasicModel.find_field { |_, field| field.name == :age }
        expect(actual).to be_kind_of(Moon::DataModel::Field)
        expect(actual.name).to eq(:age)
      end
    end

    context '.fetch_field' do
      it 'should fetch an existing field' do
        field = Fixtures::ModelTest.fetch_field(:a)
        expect(field.name).to eq(:a)
        expect(field.type).to equal(Moon::DataModel::Type[String])
      end

      it 'should fail with FieldNotFound if teh field doesn\'t exist' do
        expect { Fixtures::BasicModel.fetch_field(:egg) }.to raise_error(Moon::DataModel::FieldNotFound)
      end
    end

    context '.coerce' do
      it 'attempts to convert a given object into the model' do
        a = Fixtures::IdModel.coerce(id: 'ABC123')
        expect(a).to be_instance_of(Fixtures::IdModel)

        b = Fixtures::IdModel.coerce(a)
        expect(a).to equal(b)

        c = Fixtures::IdModel.coerce 'ABC123'
        expect(c).to eq('ABC123')
      end
    end
  end

  context '#initialize_fields' do
    it 'initializes fields given a Hash' do
      model = Fixtures::BasicModel.new(name: 'Kiddo', age: 18)
      expect(model.name).to eq('Kiddo')
      expect(model.age).to eq(18)
    end
  end

  context '#reset_fields' do
    it 'resets fields to their default value' do
      obj = Fixtures::ModelWithDefaults.new(id: '123abc', a: 'EGG', b: 2, c: [1, 2, 3], d: { egg: 3 })
      expect(obj.id).to eq('123abc')
      expect(obj.a).to eq('EGG')
      expect(obj.b).to eq(2)
      expect(obj.c).to eq([1, 2, 3])
      expect(obj.d).to eq(egg: 3)
      obj.reset_fields
      expect(obj.id).to eq('GIMME_AN_ID')
      expect(obj.a).to eq('')
      expect(obj.b).to eq(0)
      expect(obj.c).to eq([])
      expect(obj.d).to eq({})
    end
  end

  context '#field_set!' do
    it 'sets a field bypassing its validations' do
      obj = Fixtures::IdModel.new(id: '123abc')
      obj.field_set!(:id, 1)
      expect(obj.id).to eq(1)
      expect(obj).to be_invalid

      expect { obj.validate }.to raise_error(Moon::DataModel::ValidationFailed)
      obj.id = '123ABC'
      expect(obj).to be_valid
      expect { obj.validate }.not_to raise_error
    end
  end

  context '#update_fields!' do
    it 'bypasses validation and sets fields' do
      obj = Fixtures::ModelWithDefaults.new
      data = {
        id: 1, a: [], b: 'Whatever', c: nil, d: []
      }
      obj.update_fields!(data)
      expect(obj.fields).to eq(data)
      expect(obj).to be_invalid
    end
  end

  context '#assoc' do
    it 'returns a assoc array with the key, value pair' do
      obj = Fixtures::ModelWithDefaults.new
      expect(obj.assoc(:id)).to eq([:id, 'GIMME_AN_ID'])
      expect(obj.assoc(:b)).to eq([:b, 0])
    end
  end

  # Each methods
  context '#each*' do
    subject(:model) { Fixtures::ModelWithDefaults }

    context '#each_field' do
      it 'yields each Field on the model instance' do
        obj = model.new
        result = {}
        obj.each_field do |key, field|
          result[key] = field
        end
        expect(result[:id]).to eq(model.fetch_field(:id))
        expect(result[:a]).to eq(model.fetch_field(:a))
        expect(result[:b]).to eq(model.fetch_field(:b))
        expect(result[:c]).to eq(model.fetch_field(:c))
        expect(result[:d]).to eq(model.fetch_field(:d))
      end
    end

    context '#each_value' do
      it 'yields each value for the fields' do
        obj = model.new
        result = []
        obj.each_value do |value|
          result << value
        end
        expect(result).to eq(['GIMME_AN_ID', '', 0, [], {}])
      end
    end
  end

  context '#fields_hash' do
    it 'returns a Hash of its current key, value pairs' do
      obj = Fixtures::ModelWithDefaults.new
      expect(obj.fields_hash).to eq(id: 'GIMME_AN_ID', a: '', b: 0, c: [], d: {})
    end
  end

  context '#fields=' do
    it 'sets multiple fields at once' do
      obj = Fixtures::ModelWithDefaults.new
      data = {
        id: '123ABC',
        a: 'Hello',
        b: 2,
        c: [1, 2, 3],
        d: { egg: 3 }
      }
      obj.fields = data
      expect(obj.fields).to eq(data)
    end
  end

  context '#[]/=' do
    it 'gets a field by key' do
      obj = Fixtures::ModelWithDefaults.new
      expect(obj[:a]).to eq('')
    end

    it 'sets a field by key' do
      obj = Fixtures::ModelWithDefaults.new
      expect(obj[:a]).to eq('')
      obj[:a] = 'Model'
      expect(obj[:a]).to eq('Model')
    end
  end
end
