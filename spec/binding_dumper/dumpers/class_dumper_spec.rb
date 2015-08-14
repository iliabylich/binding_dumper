require 'spec_helper'

describe BindingDumper::Dumpers::ClassDumper do
  it_converts ClassWithIvarsAndCvars, {
    _klass: ClassWithIvarsAndCvars,
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

  let(:klass) { ClassWithIvarsAndCvars }
  let(:ivar) { klass.instance_variable_get(:@ivar) }
  let(:cvar) { klass.class_variable_get(:@@cvar) }

  after_deconverting(ClassWithIvarsAndCvars) do |result|
    expect(result).to eq(ClassWithIvarsAndCvars)
    expect(result.instance_variable_get(:@ivar)).to eq(123)
    expect(result.class_variable_get(:@@cvar)).to eq(456)
  end

  after_deconverting(anonymous_klass) do |result|
    expect(result).to be_a(Class)
    expect(result.name).to eq(nil)
  end
end
