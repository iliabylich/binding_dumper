require 'spec_helper'

describe BindingDumper::Dumpers::ProcDumper do
  context 'empty proc' do
    empty_proc = proc {}

    it_converts empty_proc do |result|
      expected = { _source: 'empty_proc = proc {}' }
      expect(result).to eq(expected)
    end

    after_deconverting empty_proc do |result|
      expect(result.call).to eq(nil)
    end
  end

  context 'proc with body' do
    proc_with_body = proc { 1 + 1 }

    it_converts proc_with_body do |result|
      expected = { _source: 'proc_with_body = proc { 1 + 1 }' }
      expect(result).to eq(expected)
    end

    after_deconverting proc_with_body do |result|
      expect(result.call).to eq(2)
    end
  end
end