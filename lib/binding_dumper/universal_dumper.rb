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
      Dumpers::ExistingObjectDumper,
      Dumpers::ProcDumper,
      Dumpers::ArrayDumper,
      Dumpers::ClassDumper,
      Dumpers::ObjectDumper,
      Dumpers::HashDumper,
      Dumpers::PrimitiveDumper
    ]

    extend self
    extend BindingDumper::Memories

    def converter_for(object, dumped_ids)
      DUMPERS_ON_CONVERTING.map { |dumper_klass|
        dumper_klass.new(object, dumped_ids)
      }.detect(&:can_convert?)
    end

    def convert(object, dumped_ids = [])
      converter_for(object, dumped_ids).convert
    end

    def dump(object)
      converted = convert(object)
      Marshal.dump(converted)
    end

    def deconverter_for(object)
      DUMPERS_ON_DECONVERTING.map do |dumper_klass|
        dumper_klass.new(object)
      end.detect do |dumper|
        dumper.can_deconvert?
      end
    end

    def deconvert(converted_data)
      deconverter = deconverter_for(converted_data)

      if deconverter.is_a?(Dumpers::PrimitiveDumper)
        return deconverter.deconvert
      end

      old_object_id = converted_data[:_old_object_id]

      with_memories(old_object_id) do
        deconverter.deconvert do |object|
          remember!(object, old_object_id)
        end
      end
    end

    def load(object)
      converted = Marshal.load(object)
      deconvert(converted)
    end
  end
end
