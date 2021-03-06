require 'spec_helper'

class GlobalClass
  def initialize(data)
    @data = data
  end

  def dumped_binding(*args)
    local_var = 'LOCAL'
    local_proc = proc { 2 + 2 }
    binding.dump
  end
end

describe BindingDumper::CoreExt do
  let(:object) { GlobalClass.new(:data) }
  let(:dumped) { object.dumped_binding(1,2,3) }
  subject(:dump) { Binding.load(dumped) }

  let(:dump_context) { dump.eval('self') }
  let(:local_var) { dump.eval('local_var') }
  let(:local_proc) { dump.eval('local_proc') }
  let(:ivar) { dump.eval('@data') }
  let(:arguments) { dump.eval('args') }
  let(:file) { dump.eval('__FILE__') }
  let(:line) { dump.eval('__LINE__') }
  let(:method) { dump.eval('__method__') }

  it 'dumps context' do
    expect(dump_context).to be_a(GlobalClass)
  end

  it 'dumps local vars' do
    expect(local_var).to eq('LOCAL')
  end

  it 'dumps local proc' do
    expect(local_proc.call).to eq(4)
  end

  it 'dumps instance variable' do
    expect(ivar).to eq(:data)
  end

  it 'dumps method args' do
    expect(arguments).to eq([1,2,3])
  end

  it 'patches __FILE__' do
    expect(file).to eq(__FILE__)
  end

  it 'patches __LINE__' do
    expect(line).to eq(11)
  end

  it 'patches __method__' do
    expect(method).to eq(:dumped_binding)
  end
end
