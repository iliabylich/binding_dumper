require 'spec_helper'

describe BindingDumper::Dumpers::ProcDumper do
  p1 = proc {}
  p2 = proc { 1 + 1 }

  it_converts(p1, _source: 'p1 = proc {}')
  it_converts(p2, _source: 'p2 = proc { 1 + 1 }')

  after_deconverting(p1) { |result| expect(result.call).to eq(nil) }
  after_deconverting(p2) { |result| expect(result.call).to eq(2) }
end