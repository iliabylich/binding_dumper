require 'spec_helper'

describe BindingDumper::Dumpers::HashDumper do
  h1 = {}
  h1[:self] = h1

  h2 = Hash.new { :with_default_block }

  it_converts({ })
  it_converts({ :symbol => :symbol })
  it_converts({ 123 => 123 })
  it_converts({ 123.456 => 123.456 })
  it_converts({ 'string' => 'string' })
  it_converts({ true => true })
  it_converts({ false => false })
  it_converts({ nil => nil })
  it_converts({ {} => {} })
  it_converts(h1, {self: nil})
  it_converts(h2, {})


  after_deconverting({ })                      { |result| expect(result).to eq({ }) }
  after_deconverting({ :symbol => :symbol })   { |result| expect(result).to eq({ :symbol => :symbol }) }
  after_deconverting({ 123 => 123 })           { |result| expect(result).to eq({ 123 => 123}) }
  after_deconverting({ 123.456 => 123.456 })   { |result| expect(result).to eq({ 123.456 => 123.456 }) }
  after_deconverting({ 'string' => 'string' }) { |result| expect(result).to eq({ 'string' => 'string' }) }
  after_deconverting({ true => true })         { |result| expect(result).to eq({ true => true }) }
  after_deconverting({ false => false })       { |result| expect(result).to eq({ false => false }) }
  after_deconverting({ nil => nil })           { |result| expect(result).to eq({ nil => nil }) }
  after_deconverting({ {} => {} })             { |result| expect(result).to eq({ {} => {} }) }
  after_deconverting(h1)                       { |result| expect(result).to eq({self: nil}) }
  after_deconverting(h2)                       { |result| expect(result).to eq({}) }
end

