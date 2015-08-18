require 'spec_helper'

describe BindingDumper::Dumpers::PrimitiveDumper do
  it_converts true, primitive: true
  it_converts false, primitive: true
  it_converts nil, primitive: true
  it_converts :some_symbol, primitive: true
  it_converts 'some string', primitive: true
  it_converts 123, primitive: true
  it_converts 123.456, primitive: true

  it_deconverts_back(true, primitive: true)
  it_deconverts_back(false, primitive: true)
  it_deconverts_back(nil, primitive: true)
  it_deconverts_back(:some_symbol, primitive: true)
  it_deconverts_back('some string', primitive: true)
  it_deconverts_back(123, primitive: true)
  it_deconverts_back(123.456, primitive: true)
end
