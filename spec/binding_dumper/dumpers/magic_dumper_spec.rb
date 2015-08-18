require 'spec_helper'

describe BindingDumper::Dumpers::MagicDumper do
  context 'top level data' do
    it_converts MagicFixtures::MagicClass do |result|
      expected = { _magic: 'MagicFixtures::MagicClass' }
      expect(result).to eq(expected)
    end

    after_deconverting MagicFixtures::MagicClass do |result|
      expect(result).to eq(MagicFixtures::MagicClass)
    end
  end

  context 'nested data' do
    it_converts MagicFixtures::MAGIC_DATA do |result|
      expected = { _magic: 'MagicFixtures::MagicClass.instance_variable_get(:@magic)' }
      expect(result).to eq(expected)
    end

    after_deconverting MagicFixtures::MAGIC_DATA do |result|
      expect(result).to eq(MagicFixtures::MAGIC_DATA)
    end
  end
end
