require 'spec_helper'

describe BindingDumper::Dumpers::HashDumper do
  it_converts({ })
  it_converts({ :symbol => :symbol })
  it_converts({ 123 => 123 })
  it_converts({ 123.456 => 123.456 })
  it_converts({ 'string' => 'string' })
  it_converts({ true => true })
  it_converts({ false => false })
  it_converts({ nil => nil })
  it_converts({ {} => {} })
  it_converts(recursive_hash, {self: nil})
  it_converts(hash_with_default_proc, {})


  after_deconverting({ })                      { |result| expect(result).to eq({ }) }
  after_deconverting({ :symbol => :symbol })   { |result| expect(result).to eq({ :symbol => :symbol }) }
  after_deconverting({ 123 => 123 })           { |result| expect(result).to eq({ 123 => 123}) }
  after_deconverting({ 123.456 => 123.456 })   { |result| expect(result).to eq({ 123.456 => 123.456 }) }
  after_deconverting({ 'string' => 'string' }) { |result| expect(result).to eq({ 'string' => 'string' }) }
  after_deconverting({ true => true })         { |result| expect(result).to eq({ true => true }) }
  after_deconverting({ false => false })       { |result| expect(result).to eq({ false => false }) }
  after_deconverting({ nil => nil })           { |result| expect(result).to eq({ nil => nil }) }
  after_deconverting({ {} => {} })             { |result| expect(result).to eq({ {} => {} }) }
  after_deconverting(recursive_hash)           { |result| expect(result).to eq({self: nil}) }
  after_deconverting(hash_with_default_proc)   { |result| expect(result).to eq({}) }
end

