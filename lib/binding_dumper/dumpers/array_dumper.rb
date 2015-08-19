module BindingDumper
  class Dumpers::ArrayDumper < Dumpers::Abstract
    alias_method :array, :abstract_object

    def can_convert?
      array.is_a?(Array)
    end

    def can_deconvert?
      array.is_a?(Array)
    end

    def convert
      unless should_convert?
        return { _existing_object_id: array.object_id }
      end

      dumped_ids << array.object_id

      result = array.map do |item|
        UniversalDumper.convert(item, dumped_ids)
      end

      {
        _old_object_id: array.object_id,
        _object_data: result
      }
    end

    def deconvert
      result = []
      yield result
      array.each do |converted_item|
        result << UniversalDumper.deconvert(converted_item)
      end
      result
    end
  end
end
