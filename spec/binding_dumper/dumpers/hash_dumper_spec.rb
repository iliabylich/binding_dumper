require 'spec_helper'

describe BindingDumper::Dumpers::HashDumper do
  context 'blank hash' do
    it_converts HashFixtures.blank
    it_deconverts_back HashFixtures.blank
  end

  context 'hash with symbols' do
    it_converts HashFixtures.with_symbols
    it_deconverts_back HashFixtures.with_symbols
  end

  context 'hash with strings' do
    it_converts HashFixtures.with_strings
    it_deconverts_back HashFixtures.with_strings
  end

  context 'hash with numbers' do
    it_converts HashFixtures.with_numbers
    it_deconverts_back HashFixtures.with_numbers
  end

  context 'hash with floats' do
    it_converts HashFixtures.with_floats
    it_deconverts_back HashFixtures.with_floats
  end

  context 'hash with true' do
    it_converts HashFixtures.with_true
    it_deconverts_back HashFixtures.with_true
  end

  context 'hash with false' do
    it_converts HashFixtures.with_false
    it_deconverts_back HashFixtures.with_false
  end

  context 'hash with nil' do
    it_converts HashFixtures.with_nil
    it_deconverts_back HashFixtures.with_nil
  end

  context 'deep hash' do
    it_converts HashFixtures.deep do |result|
      expected = {
        _old_object_id: HashFixtures.deep.object_id,
        _object_data: {
          {
            _old_object_id: HashFixtures.deep.keys.first.object_id,
            _object_data: {}
          } => {
            _old_object_id: HashFixtures.deep.values.first.object_id,
            _object_data: {}
          }
        }
      }
      expect(result).to eq(expected)
    end

    it_deconverts_back HashFixtures.deep
  end

  context 'recursive hash' do
    it_converts HashFixtures.recursive do |result|
      expected = {
        _old_object_id: HashFixtures.recursive.object_id,
        _object_data: {
          self: {
            _existing_object_id: HashFixtures.recursive.object_id
          }
        }
      }
      expect(result).to eq(expected)
    end

    after_deconverting HashFixtures.recursive do |result|
      expect(result).to eq(result[:self])
    end
  end

  context 'hash with default proc' do
    it_converts HashFixtures.with_default_proc
    it_deconverts_back HashFixtures.with_default_proc
  end
end

