require 'spec_helper'

describe BindingDumper::Dumpers::ObjectDumper do
  MyStruct = Struct.new(:value)
  struct = MyStruct.new(123)

  class CustomStruct
    attr_reader :value1, :value2

    def initialize(value1, value2)
      @value1 = value1
      @value2 = value2
    end

    def to_s
      "#<CustomStruct @value1=#{@value} @value2=#{@value2}>"
    end
  end

  undumpable_object = StringIO.new
  dumpable_object = CustomStruct.new(123, 456)
  partially_dumpable_object = CustomStruct.new(123, StringIO.new)

  it_converts struct, { _object: struct }
  it_converts undumpable_object, { _klass: StringIO, _undumpable: true }
  it_converts dumpable_object, { _object: dumpable_object }
  it_converts partially_dumpable_object, {
    _klass: CustomStruct,
    _ivars: {
      :@value1 => 123,
      :@value2 => { _klass: StringIO, _undumpable: true }
    }
  }

  after_deconverting(struct) { |result| expect(result).to eq(struct) }
  after_deconverting(undumpable_object) do |result|
    expect(result).to be_a(StringIO)
  end
  after_deconverting(dumpable_object) do |result|
    expect(result).to be_a(CustomStruct)
    expect(result.value1).to eq(123)
    expect(result.value2).to eq(456)
  end
  after_deconverting(partially_dumpable_object) do |result|
    expect(result).to be_a(CustomStruct)
    expect(result.value1).to eq(123)
    expect(result.value2).to be_a(StringIO)
  end
end
