require 'spec_helper'

describe BindingDumper::Dumpers::MagicDumper do
  MAGIC_DATA = 'MAGIC TEXT'
  class MagicClass
    @magic = MAGIC_DATA
  end

  around(:each) do |example|
    begin
      BindingDumper::MagicObjects.register(MagicClass)
      example.run
    ensure
      BindingDumper::MagicObjects.flush!
    end
  end

  it_converts MagicClass, { _magic: 'MagicClass' }
  it_converts MAGIC_DATA, { _magic: 'MagicClass.instance_variable_get(:@magic)' }

  after_deconverting(MagicClass) do |result|
    expect(result).to eq(MagicClass)
  end

  after_deconverting(MAGIC_DATA) do |result|
    expect(result).to eq(MAGIC_DATA)
  end
end
