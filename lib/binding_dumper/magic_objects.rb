module BindingDumper::MagicObjects
  def self.magic_tree_from(object, object_path, result = {})
    return if result[object.object_id]

    result[object.object_id] = object_path

    object.instance_variables.each do |ivar_name|
      path = "#{object_path}.instance_variable_get(:#{ivar_name})"
      ivar = object.instance_variable_get(ivar_name)
      magic_tree_from(ivar, path, result)
    end

    result
  end

  def self.register(object, object_path = object.name)
    tree = magic_tree_from(object, object_path)
    pool.merge!(tree)
    true
  end

  def self.pool
    @pool ||= {}
  end

  def self.magic?(object)
    pool.has_key?(object.object_id)
  end

  def self.get_magic(object)
    pool[object.object_id]
  end

  def self.flush!
    @pool = {}
  end
end
