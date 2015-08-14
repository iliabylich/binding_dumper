module ItConvertsHelper
  def it_converts(from, to = from, &block)
    it "converts using #{described_class}.convert #{from} to #{to}" do
      converted = described_class.new(from).convert
      if block
        instance_exec(converted, &block)
      else
        expect(converted).to eq(to)
      end
    end

    it "converts using UniversalDumper.convert #{from} to #{to}" do
      converted = BindingDumper::UniversalDumper.convert(from)
      if block
        instance_exec(converted, &block)
      else
        expect(converted).to eq(to)
      end
    end

    it "generates marshalable result for #{from}" do
      converted = BindingDumper::UniversalDumper.convert(from)
      can_be_converted = begin
        Marshal.dump(converted)
        true
      rescue Exception => e
        false
      end
      expect(can_be_converted).to eq(true)
    end
  end
end

RSpec.configure do |c|
  c.extend ItConvertsHelper
end
