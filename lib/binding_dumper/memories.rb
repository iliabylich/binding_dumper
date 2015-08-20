module BindingDumper::Memories
  def memories
    @memories ||= {}
  end

  def flush_memories!
    @memories = {}
  end

  def remember!(object, object_id)
    memories[object_id] = object
  end

  def with_memories(old_object_id, &block)
    if memories.has_key?(old_object_id)
      memories[old_object_id]
    else
      yield
    end
  end
end
