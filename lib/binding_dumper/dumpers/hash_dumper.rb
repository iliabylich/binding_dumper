module BindingDumper
  class Dumpers::HashDumper < Dumpers::Abstract
    alias_method :hash, :abstract_object

    def can_convert?
      hash.is_a?(Hash)
    end

    def can_deconvert?
      abstract_object.is_a?(Hash)
    end

    def convert
      return unless should_convert?
      new_dumped_ids = dumped_ids + [hash.object_id]

      prepared = hash.map do |k, v|
        converted_k = UniversalDumper.convert(k, dumped_ids: new_dumped_ids)
        converted_v = UniversalDumper.convert(v, dumped_ids: new_dumped_ids)
        [converted_k, converted_v]
      end
      Hash[prepared]
    end

    def deconvert
      prepared = hash.map do |converted_k, converted_v|
        k = UniversalDumper.deconvert(converted_k)
        v = UniversalDumper.deconvert(converted_v)
        [k, v]
      end
      Hash[prepared]
    end
  end
end
