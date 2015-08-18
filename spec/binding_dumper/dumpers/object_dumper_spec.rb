require 'spec_helper'

describe BindingDumper::Dumpers::ObjectDumper do
  context 'simple struct' do
    it_converts ObjectFixtures.simple_struct do |result|
      expected = { _object: ObjectFixtures.simple_struct }
      expect(result).to eq(expected)
    end

    after_deconverting ObjectFixtures.simple_struct do |result|
      expect(result).to eq(ObjectFixtures.simple_struct)
    end
  end

  context 'undumpable object' do
    it_converts ObjectFixtures.undumpable do |result|
      expected = { _klass: StringIO, _undumpable: true }
      expect(result).to eq(expected)
    end

    after_deconverting ObjectFixtures.undumpable do |result|
      expect(result).to be_a(StringIO)
    end
  end

  context 'dumpable object' do
    it_converts ObjectFixtures.dumpable do |result|
      expected = { _object: ObjectFixtures.dumpable }
      expect(result).to eq(expected)
    end

    after_deconverting ObjectFixtures.dumpable do |result|
      expect(result).to eq(ObjectFixtures.dumpable)
    end
  end

  context 'partiall dumpable object' do
    it_converts ObjectFixtures.partially_dumpable do |result|
      expected = {
        _klass: ObjectFixtures.partially_dumpable.class,
        _ivars: {
          :@value1 => 123,
          :@value2 => {
            _klass: StringIO,
            _undumpable: true
          }
        },
        _old_object_id: ObjectFixtures.partially_dumpable.object_id
      }
      expect(result).to eq(expected)
    end

    after_deconverting ObjectFixtures.partially_dumpable do |result|
      expect(result).to be_a(ObjectFixtures.partially_dumpable.class)
      expect(result.value1).to eq(123)
      expect(result.value2).to be_a(StringIO)
    end
  end

  context 'dumpable recursive object' do
    it_converts ObjectFixtures.dumpable_recursive do |result|
      expected = { _object: ObjectFixtures.dumpable_recursive }
      expect(result).to eq(expected)
    end

    after_deconverting ObjectFixtures.dumpable_recursive do |result|
      expect(result).to be_a(ObjectFixtures.dumpable_recursive.class)
      expect(result.value1).to eq(result)
      expect(result.value2).to eq(result)
    end
  end

  context 'undumpable recursive object' do
    it_converts ObjectFixtures.undumpable_recursive do |result|
      expected = {
        _klass: ObjectFixtures::CustomRecursiveStruct,
        _ivars: {
          :@value1 => {
            _existing_object_id: ObjectFixtures.undumpable_recursive.object_id
          },
          :@value2 => {
            _klass: StringIO,
            _undumpable: true
          }
        },
        _old_object_id: ObjectFixtures.undumpable_recursive.object_id
      }
      expect(result).to eq(expected)
    end
  end
end
