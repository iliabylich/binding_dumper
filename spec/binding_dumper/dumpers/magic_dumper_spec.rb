require 'spec_helper'

describe BindingDumper::Dumpers::MagicDumper do
  it_converts MagicClass, { _magic: 'MagicClass' }
  it_converts MAGIC_DATA, { _magic: 'MagicClass.instance_variable_get(:@magic)' }

  after_deconverting(MagicClass) do |result|
    expect(result).to eq(MagicClass)
  end

  after_deconverting(MAGIC_DATA) do |result|
    expect(result).to eq(MAGIC_DATA)
  end
end
