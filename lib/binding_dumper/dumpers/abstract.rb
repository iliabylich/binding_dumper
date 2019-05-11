# Class with common functionality of all dumpers
#
class BindingDumper::Dumpers::Abstract
  # Returns array of object ids that has been already converted
  #
  # @return [Array<Fixnum>]
  #
  attr_reader :dumped_ids

  # @param abstract_object [Object] any object
  # @param dumped_ids [Array<Fixnum>] list of object ids that are already dumped
  #
  def initialize(abstract_object, dumped_ids = [])
    @abstract_object = abstract_object
    @dumped_ids = dumped_ids
  end

  private

  # Returns abstract object
  #  Sometimes it's a Hash that represents object structure
  #  Sometimes it's just that object (if its' primitive)
  #
  # @return [Object]
  #
  def abstract_object
    if @abstract_object.is_a?(Hash) && @abstract_object.has_key?(:_object_data)
      @abstract_object[:_object_data]
    else
      @abstract_object
    end
  end

  # Returns +true+ if +abstract_object+ should be converted
  #
  # @return [true, false]
  #
  def should_convert?
    !dumped_ids.include?(abstract_object.object_id)
  end

  # Returns true if +abstract_object+ can be dumped using Marshal.dump
  #
  # @return [true, false]
  #
  def can_be_fully_dumped?(object)
    begin
      Marshal.dump(object)
      true
    rescue TypeError, IOError
      false
    end
  end

  # Returns +true+ if undumpable object (like StringIO.new)
  #  can't be dumped itself, but it's blank copy can be dumped
  #
  # @return [true, false]
  #
  def can_be_dumped_as_copy?(object)
    begin
      copy = object.class.allocate
      Marshal.dump(copy)
      true
    rescue StandardError
      false
    end
  end

  # Returns +true+ if object can't be marshaled
  #
  # @return [true, false]
  #
  def undumpable?(object)
    !can_be_fully_dumped?(object) && !can_be_dumped_as_copy?(object)
  end
end
