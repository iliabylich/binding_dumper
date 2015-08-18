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

    def converter_for(object)
      DUMPERS_ON_CONVERTING.detect do |dumper_klass|
        dumper_klass.new(object).can_convert?
      end
    end

    def convert(object, dumped_ids: [])
      converter = converter_for(object)
      converter.new(object, dumped_ids: dumped_ids).convert
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
      object_data = if converted_data.is_a?(Hash) && converted_data.has_key?(:_object_data)
        converted_data[:_object_data]
      else
        converted_data
      end

      deconverter = deconverter_for(object_data)
      if deconverter == Dumpers::PrimitiveDumper
        return deconverter.new(object_data).deconvert
      end
      old_object_id = converted_data[:_old_object_id]
      with_memories(old_object_id) do
        result = deconverter.new(object_data).deconvert do |object|
          remember!(object, old_object_id)
        end
        result
      end
    end

    def load(object)
      converted = Marshal.load(object)
      deconvert(converted)
    end

    def memories
      @memories ||= {}
    end

    def flush_memories!
      @memories = {}
    end

    def with_memories(old_object_id, &block)
      if memories.has_key?(old_object_id)
        memories[old_object_id]
      else
        yield
      end
    end

    def remember!(object, object_id)
      @memories[object_id] = object
    end
  end
end
