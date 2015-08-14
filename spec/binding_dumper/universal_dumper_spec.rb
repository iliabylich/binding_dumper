require 'spec_helper'

def dump(value)
  BindingDumper::UniversalDumper.dump(value)
end

def dump_and_load(value)
  BindingDumper::UniversalDumper.load(BindingDumper::UniversalDumper.dump(value))
end

describe BindingDumper::UniversalDumper do
  subject(:dumper) { described_class }

  def self.it_dumps_and_loads_back(value)
    it "dumps #{value}" do
      expect(dump(value)).to be_a(String)
    end

    it "loads #{value} back" do
      expect(dump_and_load(value)).to eq(value)
    end
  end

  def self.it_dumps_and_loads_copy(value, &block)
    it "dumps #{value}" do
      expect(dump(value)).to be_a(String)
    end

    it "loads copy of #{value}" do
      result = dump_and_load(value)
      instance_exec(result, &block)
    end
  end

  Point = Struct.new(:x, :y)

  it_dumps_and_loads_back nil
  it_dumps_and_loads_back true
  it_dumps_and_loads_back false
  it_dumps_and_loads_back 'string'
  it_dumps_and_loads_back :symbol
  it_dumps_and_loads_back []
  it_dumps_and_loads_back [1,2,3]
  it_dumps_and_loads_back({})
  it_dumps_and_loads_back({ a: 'b' })
  it_dumps_and_loads_back Point.new(13, 25.6)
  it_dumps_and_loads_back Class
  it_dumps_and_loads_back({Class => 17})

  context 'procs dumping' do
    let(:sample) do
      proc { 2 + 2 }
    end

    it 'dumps proc to string' do
      expect(dump(sample)).to be_a(String)
    end

    it 'dumps and loads back proc as proc' do
      loaded = dump_and_load(sample)
      expect(loaded.call).to eq(4)
    end
  end

  it_dumps_and_loads_copy StringIO.new do |result|
    expect(result).to be_instance_of(StringIO)
  end

  it_dumps_and_loads_copy IO.new(1) do |result|
    expect(result).to be_instance_of(IO)
  end

  it_dumps_and_loads_copy STDOUT do |result|
    expect(result).to be_instance_of(IO)
  end

  it_dumps_and_loads_copy [StringIO.new] do |result|
    expect(result).to be_an(Array)
    expect(result.length).to eq(1)
    expect(result[0]).to be_a(StringIO)
  end

  it_dumps_and_loads_copy({ 123 => StringIO.new }) do |result|
    expect(result).to be_a(Hash)
    expect(result.keys).to eq([123])
    expect(result[123]).to be_a(StringIO)
  end
end
