require 'spec_helper'

describe BindingDumper::Dumpers::ObjectDumper do
  context 'simple struct' do
    struct = MyStruct.new(123)

    it_converts struct, { _object: struct }

    after_deconverting(struct) { |result| expect(result).to eq(struct) }
  end

  context 'undumpable object' do
    undumpable_object = StringIO.new

    it_converts undumpable_object, { _klass: StringIO, _undumpable: true }

    after_deconverting(undumpable_object) do |result|
      expect(result).to be_a(StringIO)
    end
  end

  context 'dumpable object' do
    dumpable_object = CustomStruct.new(123, 456)

    it_converts dumpable_object, { _object: dumpable_object }

    after_deconverting(dumpable_object) do |result|
      expect(result).to be_a(CustomStruct)
      expect(result.value1).to eq(123)
      expect(result.value2).to eq(456)
    end
  end

  context 'partiall dumpable object' do
    partially_dumpable_object = CustomStruct.new(123, StringIO.new)

    it_converts partially_dumpable_object do |result|
      expect(result).to be_a(Hash)
      expect(result[:_klass]).to eq(CustomStruct)
      expect(result[:_ivars][:@value1]).to eq(123)
      expect(result[:_ivars][:@value2]).to eq({ _klass: StringIO, _undumpable: true })
    end

    after_deconverting(partially_dumpable_object) do |result|
      expect(result).to be_a(CustomStruct)
      expect(result.value1).to eq(123)
      expect(result.value2).to be_a(StringIO)
    end
  end

  context 'dumpable recursive object' do
    dumpable_recursive_object = CustomRecursiveStruct.allocate
    dumpable_recursive_object.value1 = dumpable_recursive_object
    dumpable_recursive_object.value2 = dumpable_recursive_object

    it_converts dumpable_recursive_object, { _object: dumpable_recursive_object }
  end

  context 'undumpable recursive object' do
    undumpable_recursive_object = CustomRecursiveStruct.allocate
    undumpable_recursive_object.value1 = undumpable_recursive_object
    undumpable_recursive_object.value2 = StringIO.new

    it_converts undumpable_recursive_object do |result|
      expect(result).to be_a(Hash)
      expect(result[:_klass]).to eq(CustomRecursiveStruct)
      expect(result[:_ivars][:@value1]).to eq({ _existing_object_id: result[:_old_object_id] })
      expect(result[:_ivars][:@value2]).to eq({ _klass: StringIO, _undumpable: true })
    end
  end
end
