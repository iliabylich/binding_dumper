module BindingDumper
  # Module that puts together all existing dumpers and wraps their functionality
  #
  # This dumper can dump and load back _any_ object using system of existing dumpers.
  #
  # @example
  #  dump = BindingDumper::UniversalDumper.dump(Object.new)
  #  restored = BindingDumper::UniversalDumper.load(dump)
  #  # => #<Object>
  #
  module UniversalDumper
    DUMPERS_ON_CONVERTING = [
      Dumpers::PrimitiveDumper,
      Dumpers::MagicDumper,
      Dumpers::ProcDumper,
      Dumpers::ClassDumper,
      Dumpers::ArrayDumper,
      Dumpers::HashDumper,
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

    # Returns converter that should be applied to provided +object+
    #
    # @param object [Object]
    # @param dumped_ids [Array<Fixum>] list of object_ids that are already dumped
    #
    # @return [BindingDumper::Dumpers::Abstract]
    #
    def converter_for(object, dumped_ids)
      DUMPERS_ON_CONVERTING.map { |dumper_klass|
        dumper_klass.new(object, dumped_ids)
      }.detect(&:can_convert?)
    end

    # Converts passed +object+ to marshalable string
    #
    # @param object [Object]
    # @param dumped_ids [Array<Fixnum>] list of object_ids that are already dumped
    #
    # @return [Hash]
    #
    def convert(object, dumped_ids = [])
      converter_for(object, dumped_ids).convert
    end

    # Dump passed +object+ to string
    #
    # @param object [Object]
    #
    # @return [String]
    #
    def dump(object)
      converted = convert(object)
      Marshal.dump(converted)
    end

    # Returns deconverter that should be applied to provided +object+
    #
    # @param object [Object]
    #
    # @return [BindingDumper::Dumpers::Abstract]
    #
    def deconverter_for(object)
      DUMPERS_ON_DECONVERTING.map do |dumper_klass|
        dumper_klass.new(object)
      end.detect do |dumper|
        dumper.can_deconvert?
      end
    end

    # Deconverts passed +object+ to marshalable string
    #
    # @param object [Object]
    #
    # @return [Object]
    #
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

    # Loads dumped object back to its original state
    #
    # @param object [String]
    #
    # @return [Object]
    #
    def load(object)
      converted = Marshal.load(object)
      deconvert(converted)
    end
  end
end
