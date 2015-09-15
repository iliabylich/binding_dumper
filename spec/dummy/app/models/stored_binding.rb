class StoredBinding < ActiveRecord::Base
  include BindingDumper::LoadSupport::ActiveRecord

  def column_with_binding
    :data
  end
end
