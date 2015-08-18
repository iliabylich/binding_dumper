require 'spec_helper'

describe BindingDumper::Dumpers::ArrayDumper do
  context 'blank array' do
    it_converts ArrayFixtures.blank
    it_deconverts_back ArrayFixtures.blank
  end

  context 'array with symbol' do
    it_converts ArrayFixtures.with_symbol
    it_deconverts_back ArrayFixtures.with_symbol
  end

  context 'array with number' do
    it_converts ArrayFixtures.with_number
    it_deconverts_back ArrayFixtures.with_number
  end

  context 'array with float' do
    it_converts ArrayFixtures.with_float
    it_deconverts_back ArrayFixtures.with_float
  end

  context 'array with string' do
    it_converts ArrayFixtures.with_string
    it_deconverts_back ArrayFixtures.with_string
  end

  context 'array with true' do
    it_converts ArrayFixtures.with_true
    it_deconverts_back ArrayFixtures.with_true
  end

  context 'array with false' do
    it_converts ArrayFixtures.with_false
    it_deconverts_back ArrayFixtures.with_false
  end

  context 'array with nil' do
    it_converts ArrayFixtures.with_nil
    it_deconverts_back ArrayFixtures.with_nil
  end

  context 'deep array' do
    it_converts ArrayFixtures.deep do |result|
      expected = {
        _old_object_id: ArrayFixtures.deep.object_id,
        _object_data: [
          {
            _old_object_id: ArrayFixtures.deep[0].object_id,
            _object_data: [
              {
                _old_object_id: ArrayFixtures.deep[0][0].object_id,
                _object_data: []
              }
            ]
          }
        ]
      }
      expect(result).to eq(expected)
    end

    it_deconverts_back ArrayFixtures.deep
  end

  context 'recursive array' do
    it_converts ArrayFixtures.recursive do |result|
      expected = {
        _old_object_id: ArrayFixtures.recursive.object_id,
        _object_data: [
          {
            _existing_object_id: ArrayFixtures.recursive.object_id
          }
        ]
      }
      expect(result).to eq(expected)
    end

    after_deconverting ArrayFixtures.recursive do |result|
      expect(result).to equal(result[0])
    end
  end

  context 'undumpable array' do
    it_converts ArrayFixtures.undumpable do |result|
      expected = {
        _old_object_id: ArrayFixtures.undumpable.object_id,
        _object_data: [
          {
            _klass: StringIO,
            _undumpable: true
          }
        ]
      }
      expect(result).to eq(expected)
    end

    after_deconverting ArrayFixtures.undumpable do |result|
      expect(result).to be_an(Array)
      expect(result[0]).to be_a(StringIO)
    end
  end
end
