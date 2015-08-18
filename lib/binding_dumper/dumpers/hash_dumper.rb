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
      unless should_convert?
        return { _existing_object_id: hash.object_id }
      end

      dumped_ids << hash.object_id

      prepared = hash.map do |k, v|
        converted_k = UniversalDumper.convert(k, dumped_ids: dumped_ids)
        converted_v = UniversalDumper.convert(v, dumped_ids: dumped_ids)
        [converted_k, converted_v]
      end

      result = Hash[prepared]

      {
        _old_object_id: hash.object_id,
        _object_data: result
      }
    end

    def deconvert
      result = {}
      yield result
      hash.each do |converted_k, converted_v|
        k = UniversalDumper.deconvert(converted_k)
        v = UniversalDumper.deconvert(converted_v)
        result[k] = v
      end
      result
    end
  end
end
