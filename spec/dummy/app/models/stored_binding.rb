class StoredBinding < ActiveRecord::Base
  def debug
    require 'rails/backtrace_cleaner'
    Binding.load(data).pry
  end
end
