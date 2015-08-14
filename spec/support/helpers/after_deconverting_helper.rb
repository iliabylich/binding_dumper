module AfterDeconvertingHelper
  def after_deconverting(object, &block)
    it "converts and deconverts using #{described_class} object #{object}" do
      converted = described_class.new(object).convert
      deconverted = described_class.new(converted).deconvert
      instance_exec(deconverted, &block)
    end

    it "converts and deconverts using UniversalDumper.convert/deconvert object #{object}" do
      converted = BindingDumper::UniversalDumper.convert(object)
      deconverted = BindingDumper::UniversalDumper.deconvert(converted)
      instance_exec(deconverted, &block)
    end
  end
end

RSpec.configure do |c|
  c.extend AfterDeconvertingHelper
end
