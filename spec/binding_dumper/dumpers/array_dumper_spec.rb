require 'spec_helper'

describe BindingDumper::Dumpers::ArrayDumper do
  it_converts []
  it_converts [:symbol]
  it_converts [123]
  it_converts [123.456]
  it_converts ['string']
  it_converts [true]
  it_converts [false]
  it_converts [nil]
  it_converts [[[]]]
  it_converts recursive_array, [nil]
  it_converts [IO.new(1)], [{ _klass: IO, _undumpable: true }]


  after_deconverting([])              { |result| expect(result).to eq([]) }
  after_deconverting([:symbol])       { |result| expect(result).to eq([:symbol]) }
  after_deconverting([123])           { |result| expect(result).to eq([123]) }
  after_deconverting([123.456])       { |result| expect(result).to eq([123.456]) }
  after_deconverting(['string'])      { |result| expect(result).to eq(['string']) }
  after_deconverting([true])          { |result| expect(result).to eq([true]) }
  after_deconverting([false])         { |result| expect(result).to eq([false]) }
  after_deconverting([nil])           { |result| expect(result).to eq([nil]) }
  after_deconverting([[[]]])          { |result| expect(result).to eq([[[]]]) }
  after_deconverting(recursive_array) { |result| expect(result).to eq([nil]) }
  after_deconverting([IO.new(1)]) do |result|
    expect(result).to be_an(Array)
    expect(result.length).to eq(1)
    expect(result[0]).to be_a(IO)
  end
end
