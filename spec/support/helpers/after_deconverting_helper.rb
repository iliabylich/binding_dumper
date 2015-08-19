module AfterDeconvertingHelper
  def after_deconverting(object, &block)
    it "converts and deconverts using UniversalDumper.convert/deconvert object #{object}" do
      converted = BindingDumper::UniversalDumper.convert(object)
      deconverted = BindingDumper::UniversalDumper.deconvert(converted)
      instance_exec(deconverted, &block)
    end
  end

  def it_deconverts_back(object, options = { primitive: false })
    it "converts and deconverts using UniversalDumper.convert/deconvert object #{object}" do
      converted = BindingDumper::UniversalDumper.convert(object)
      deconverted = BindingDumper::UniversalDumper.deconvert(converted)

      if options[:primitive]
        expect(object).to equal(deconverted)
      else
        expect(object).to eq(deconverted)
        expect(object).to_not equal(deconverted)
      end
    end
  end
end

RSpec.configure do |c|
  c.extend AfterDeconvertingHelper
end
