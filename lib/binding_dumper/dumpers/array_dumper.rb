class BindingDumper::Dumpers::ArrayDumper < BindingDumper::Dumpers::Abstract
  alias_method :array, :abstract_object

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
