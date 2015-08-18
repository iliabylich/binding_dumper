class StoredBinding < ActiveRecord::Base
  def debug
    stored_binding.pry
  end

  def stored_binding
    require 'rails/backtrace_cleaner'
    BindingDumper::UniversalDumper.flush_memories!
    Binding.load(data)
  end
end
