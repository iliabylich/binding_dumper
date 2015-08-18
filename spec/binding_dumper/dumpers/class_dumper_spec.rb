require 'spec_helper'

describe BindingDumper::Dumpers::ClassDumper do
  context 'simple klass' do
    it_converts ClassFixtures::WithIvarsAndCvars do |result|
      expected = {
        _klass: ClassFixtures::WithIvarsAndCvars,
        _ivars: {
          :@ivar => 123
        },
        _cvars: {
          :@@cvar => 456
        }
      }
      expect(result).to eq(expected)
    end

    after_deconverting(ClassFixtures::WithIvarsAndCvars) do |result|
      expect(result).to eq(ClassFixtures::WithIvarsAndCvars)
      expect(result.instance_variable_get(:@ivar)).to eq(123)
      expect(result.class_variable_get(:@@cvar)).to eq(456)
    end
  end

  context 'anonymous klass' do
    it_converts ClassFixtures.anonymous_klass do |result|
      expected = { _anonymous: true }
      expect(result).to eq(expected)
    end

    after_deconverting ClassFixtures.anonymous_klass do |result|
      expect(result).to be_a(Class)
      expect(result.name).to eq(nil)
    end
  end
end
