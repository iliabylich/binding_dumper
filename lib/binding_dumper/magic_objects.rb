# Module responsible for storing and retrieving 'magical' objects
#  Object is 'magical' if it's the same for every Ruby process
#
# Examples of 'magical' objects:
#  Rails.application
#  Rails.env
#  Rails.application.config
#
# To register an object, run:
# @example
#   BindingDumper::MagicObjects.register(MyClass)
#   # or if it's method that returns always the same data
#   BindingDumper::MagicObjects.register(:some_method, 'send(:some_method)')
#
# After marking an object as 'magical' it (and all embedded objects)
#  will be added to the object pool of 'magical' objects
#
# @example
#   class A
#     class << self
#       attr_reader :config
#       @config = { config: :data }
#     end
#   end
#
#   BindingDumper::MagicObjects.register(A)
#   BindingDumper::MagicObjects.pool
#   {
#     47472500 => "A",
#     600668   => "A.instance_variable_get(:@config)"
#   }
#   BindingDumper::MagicObjects.magic?(A.config)
#   # => true
#   BindingDumper::MagicObjects.get_magic(A.config)
#   # => "A.instance_variable_get(:@config)"
#
module BindingDumper::MagicObjects
  # Builds a tree of objects inside of passed +object+
  #
  # @param object [Object] object to build a tree from
  # @param object_path [#to_s] a string that return a passed object after 'eval'-uation
  # @param result [Hash] accumulator for recursion
  #
  # @return [Hash]
  #
  def self.grow_magic_tree!(object, object_path, tree = {})
    return if object.nil?
    return if tree[object.object_id]

    tree[object.object_id] = object_path

    object.instance_variables.each do |ivar_name|
      path = "#{object_path}.instance_variable_get(:#{ivar_name})"
      ivar = object.instance_variable_get(ivar_name)
      grow_magic_tree!(ivar, path, tree)
    end

    case object
    when Array
      object.each_with_index do |item, idx|
        path = "#{object_path}[#{idx}]"
        grow_magic_tree!(item, path, tree)
      end
    when Hash
      object.each do |key, value|
        path = "#{object_path}[#{key.inspect}]"
        grow_magic_tree!(value, path, tree)
      end
    end
  end

  # Registers passed object as 'magical'
  #
  # @param object [Object]
  # @param object_path [String]  the way how to get an object
  #
  def self.register(object, object_path = object.name)
    tree = {}
    grow_magic_tree!(object, object_path, tree)
    pool.merge!(tree)
    true
  end

  # Returns Hash containing all magical objects
  #
  # @return [Hash] in format { object_id => way to get an object }
  #
  def self.pool
    @pool ||= {}
  end

  # Returns true if passed +object+ is 'magical'
  #
  # @return [true, false]
  #
  def self.magic?(object)
    pool.has_key?(object.object_id)
  end

  # Returns the way to get a 'magical' object
  #
  # @param object [Object]
  #
  # @return [String]
  #
  def self.get_magic(object)
    pool[object.object_id]
  end

  # Flushes existing information about 'magical' objects
  #
  def self.flush!
    @pool = {}
  end

  # @private
  def self.flush_while
    dump, @pool = @pool, {}
    yield
  ensure
    @pool = dump
  end
end
