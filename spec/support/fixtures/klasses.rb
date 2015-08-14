# Classes

class ClassWithIvarsAndCvars
  @ivar = 123
  @@cvar = 456
end

def anonymous_klass
  @anonymous_klass ||= Class.new
end


# Arrays

def recursive_array
  @recursive_array ||= begin
    a = []
    a[0] = a
  end
end

# Hashes

def recursive_hash
  @recursive_hash ||= begin
    h1 = {}
    h1[:self] = h1
  end
end

def hash_with_default_proc
  @hash_with_default_proc ||= Hash.new { :with_default_block }
end

# MAGIC objects

MAGIC_DATA = 'MAGIC TEXT'
class MagicClass
  @magic = MAGIC_DATA
end

RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      BindingDumper::MagicObjects.register(MagicClass)
      example.run
    ensure
      BindingDumper::MagicObjects.flush!
    end
  end
end

# Objects

MyStruct = Struct.new(:value)

class CustomStruct
  attr_accessor :value1, :value2

  def initialize(value1, value2)
    @value1 = value1
    @value2 = value2
  end

  def to_s
    "#<CustomStruct @value1=#{value1} @value2=#{value2}>"
  end
end

class CustomRecursiveStruct < CustomStruct
  def to_s
    "#<CustomRecursiveStruct ...>"
  end
end
