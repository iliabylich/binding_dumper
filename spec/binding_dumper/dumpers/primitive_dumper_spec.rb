require 'spec_helper'

describe BindingDumper::Dumpers::PrimitiveDumper do
  it_converts true
  it_converts false
  it_converts nil
  it_converts :some_symbol
  it_converts 'some string'
  it_converts 123
  it_converts 123.456

  after_deconverting(true)          { |result| expect(result).to eq(true) }
  after_deconverting(false)         { |result| expect(result).to eq(false) }
  after_deconverting(nil)           { |result| expect(result).to eq(nil) }
  after_deconverting(:some_symbol)  { |result| expect(result).to eq(:some_symbol) }
  after_deconverting('some string') { |result| expect(result).to eq('some string') }
  after_deconverting(123)           { |result| expect(result).to eq(123) }
  after_deconverting(123.456)       { |result| expect(result).to eq(123.456) }
end
