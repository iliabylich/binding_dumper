module BindingDumper::LoadSupport::ActiveRecord
  def column_with_binding
    raise NotImplementedError, 'You must define a column that contains binding data'
  end

  def stored_binding
    BindingDumper::UniversalDumper.flush_memories!
    data = read_attribute(column_with_binding)
    Binding.load(data)
  end

  def debug
    stored_binding.pry
  end
end
