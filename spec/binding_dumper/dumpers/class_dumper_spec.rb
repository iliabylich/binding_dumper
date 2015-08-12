require 'spec_helper'

describe BindingDumper::Dumpers::ClassDumper do
  class self::TestClass
    @ivar = 123
    @@cvar = 456
  end

  anonymous_klass = Class.new

  it_converts self::TestClass, {
    _klass: self::TestClass,
    _ivars: {
      :@ivar => 123
    },
    _cvars: {
      :@@cvar => 456
    }
  }

  it_converts anonymous_klass, {
    _anonymous: true
  }

  let(:klass) { self.class::TestClass }
  let(:ivar) { klass.instance_variable_get(:@ivar) }
  let(:cvar) { klass.class_variable_get(:@@cvar) }

  after_deconverting(self::TestClass) do |result|
    expect(result).to eq(klass)
    expect(ivar).to eq(123)
    expect(cvar).to eq(456)
  end

  after_deconverting(anonymous_klass) do |result|
    expect(result).to be_a(Class)
    expect(result.name).to eq(nil)
  end
end
