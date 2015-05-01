require 'spec_helper'
require 'data_model/type_validators'

context do
  subject(:type) { Moon::DataModel::Type }
  subject(:validation_err) { Moon::DataModel::TypeValidationError }

  shared_examples 'TypeValidator' do

    context '.check_type' do
      it 'should return true' do
        expect(described_class.check_type(type[Integer], 1)).to eq([true, nil])
      end

      it 'validates simple types' do
        described_class.check_type(type[Integer], 187)
        described_class.check_type(type[String], 'Hello World')
      end

      it 'validates types that are descendants' do
        described_class.check_type(type[Numeric], 187)
        described_class.check_type(type[Numeric], 1.0)
      end

      it 'validates a composite Array types' do
        described_class.check_type(type[Array[String]], ['Hello World', 'My String'])
      end

      it 'validates a composite Hash types' do
        described_class.check_type(type[Hash[String => Integer]], { 'Hello World' => 12, 'My String' => 24 })
      end

      it 'should error on wrong type' do
        rs =
        expect { described_class.check_type(type[String], 1) }.to raise_error(validation_err)
        expect { described_class.check_type(type[String], []) }.to raise_error(validation_err)
        expect { described_class.check_type(type[String], {}) }.to raise_error(validation_err)

        expect { described_class.check_type(type[Integer], 'Oh noes') }.to raise_error(validation_err)
        expect { described_class.check_type(type[Integer], []) }.to raise_error(validation_err)
        expect { described_class.check_type(type[Integer], {}) }.to raise_error(validation_err)

        expect { described_class.check_type(type[Array], {}) }.to raise_error(validation_err)
        expect { described_class.check_type(type[Array], 1) }.to raise_error(validation_err)
        expect { described_class.check_type(type[Array], 'str') }.to raise_error(validation_err)

        expect { described_class.check_type(type[Hash], []) }.to raise_error(validation_err)
        expect { described_class.check_type(type[Hash], 'str') }.to raise_error(validation_err)
        expect { described_class.check_type(type[Hash], 1) }.to raise_error(validation_err)
      end

      it 'should validate a composite hash type' do
        described_class.check_type(type[Hash[String => Integer]], { 'Hello World' => 12, 'My String' => 24 })
      end

      it 'should validate a deep nested composite hash type' do
        described_class.check_type(type[Hash[String => Array[Integer]]], { 'Hello World' => [12], 'My String' => [24] })
      end
    end
  end

  describe Moon::DataModel::TypeValidators::Null do
    it 'should return true' do
      expect(described_class.check_type(type[Integer], 1)).to eq([true, nil])
    end
  end

  describe Moon::DataModel::TypeValidators::Soft do
    it_behaves_like 'TypeValidator'
  end

  describe Moon::DataModel::TypeValidators::Verbose do
    it_behaves_like 'TypeValidator'

    it 'errors on invalid composite Array content' do
      array_of_ints_type = type[Array[Integer]]
      expect { described_class.check_type(array_of_ints_type, [12, 'Oh noes']) }.to raise_error(validation_err)
    end

    it 'errors on invalid composite Hash content' do
      hash_str_int = type[Hash[String => Integer]]
      expect { described_class.check_type(hash_str_int, { 'This' => 12, 'Hello' => 'World' }) }.to raise_error(validation_err)
    end
  end
end
