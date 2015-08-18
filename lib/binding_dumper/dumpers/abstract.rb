class BindingDumper::Dumpers::Abstract
  attr_reader :abstract_object, :dumped_ids

  def initialize(abstract_object, dumped_ids: [])
    @abstract_object = abstract_object
    @dumped_ids = dumped_ids
  end

  private

  def should_convert?
    !dumped_ids.include?(abstract_object.object_id)
  end

  def can_be_fully_dumped?(object)
    begin
      Marshal.dump(object)
      true
    rescue TypeError, IOError
      false
    end
  end

  def can_be_dumped_as_copy?(object)
    begin
      copy = object.class.allocate
      Marshal.dump(copy)
      true
    rescue TypeError, IOError
      false
    end
  end

  def undumpable?(object)
    !can_be_fully_dumped?(object) && !can_be_dumped_as_copy?(object)
  end
end
