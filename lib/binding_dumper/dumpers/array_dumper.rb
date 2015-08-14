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
      return unless should_convert?
      new_dumped_ids = dumped_ids + [array.object_id]

      array.map do |item|
        UniversalDumper.convert(item, dumped_ids: new_dumped_ids)
      end
    end

    def deconvert
      array.map do |converted_item|
        UniversalDumper.deconvert(converted_item)
      end
    end
  end
end
