class StoredBinding < ActiveRecord::Base
  def debug
    Binding.load(data).pry
  end
end
