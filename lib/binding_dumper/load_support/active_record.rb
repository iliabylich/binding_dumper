# ActiveRecord extension for storing and retrieving dumped bindings
#
# @example
#   class StoredBinding < ActiveRecord::Base
#     include BindingDumper::LoadSupport::ActiveRecord
#
#     def column_with_binding
#       :data
#     end
#   end
#
#   StoredBinding.create(data: binding.dump)
#
#   StoredBinding.last.debug
#
module BindingDumper::LoadSupport::ActiveRecord
  # Returns a column name that stores a dumped binding
  #
  # @return [#to_s]
  #
  def column_with_binding
    raise NotImplementedError, 'You must define a column that contains binding data'
  end

  # Loads a binding stored in +column_with_binding+ column
  #
  # @return [Binding]
  #
  def stored_binding
    require 'rails/backtrace_cleaner'
    BindingDumper::UniversalDumper.flush_memories!
    data = read_attribute(column_with_binding)
    Binding.load(data)
  end

  # Invokes '.pry' on +stored_binding+
  #
  # @return nil
  #
  def debug
    stored_binding.pry
  end
end
