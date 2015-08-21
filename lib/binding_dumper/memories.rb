# Module for storing mapping { dumped object_id => restored object }
#  used for BindingDumper::Dumpers::ExistingObjectDumper strategy
#
# @see BindingDumper::UniversalDumper
# @example
#   BindingDumper::UniversalDumper.memories
#   # => {}
#   o = Object.new
#   BindingDumper::UniversalDumper.remember!(123, o)
#   BindingDumper::UniversalDumper.with_memories(123) == o
#   # => true
#
module BindingDumper::Memories
  # Returns hash containing all restored objects
  #
  # @return [Hash]
  #
  def memories
    @memories ||= {}
  end

  # Flushes existing memories about restored objects
  #
  def flush_memories!
    @memories = {}
  end

  # Saves passed +object+ and marks it with +object_id+
  #
  # @param object [Object]
  # @param object_id [Fixnum]
  #
  def remember!(object, object_id)
    memories[object_id] = object
  end

  # Returns an object from memories with +old_object_id+
  #  or yields
  #
  # @param old_object_id [Fixnum]
  #
  # @yield
  #
  def with_memories(old_object_id, &block)
    if memories.has_key?(old_object_id)
      memories[old_object_id]
    else
      yield
    end
  end
end
