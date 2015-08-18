class StoredBinding < ActiveRecord::Base
  def debug
    require 'rails/backtrace_cleaner'
    BindingDumper::UniversalDumper.flush_memories!
    Binding.load(data).pry
  end
end
