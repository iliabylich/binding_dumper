module BindingDumper
  module UniversalDumper
    DUMPERS_ON_CONVERTING = [
      Dumpers::MagicDumper,
      Dumpers::ProcDumper,
      Dumpers::ClassDumper,
      Dumpers::ArrayDumper,
      Dumpers::HashDumper,
      Dumpers::PrimitiveDumper,
      Dumpers::ObjectDumper
    ]

    DUMPERS_ON_DECONVERTING = [
      Dumpers::MagicDumper,
      Dumpers::ProcDumper,
      Dumpers::ArrayDumper,
      Dumpers::ClassDumper,
      Dumpers::ObjectDumper,
      Dumpers::HashDumper,
      Dumpers::PrimitiveDumper
    ]

    extend self

    def converter_for(object)
      DUMPERS_ON_CONVERTING.detect do |dumper_klass|
        dumper_klass.new(object).can_convert?
      end
    end

    def convert(object, dumped_ids: [])
      converter_for(object).new(object, dumped_ids: dumped_ids).convert
    end

    def dump(object)
      converted = convert(object)
      Marshal.dump(converted)
    end

    def deconverter_for(object)
      DUMPERS_ON_DECONVERTING.detect do |dumper_klass|
        dumper_klass.new(object).can_deconvert?
      end
    end

    def deconvert(converted_data)
      deconverter = deconverter_for(converted_data)
      deconverter.new(converted_data).deconvert
    end

    def load(object)
      converted = Marshal.load(object)
      deconvert(converted)
    end
  end
end
