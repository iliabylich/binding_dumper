# Classes

module ClassFixtures
  extend self

  class WithIvarsAndCvars
    @ivar = 123
    @@cvar = 456
  end

  def anonymous_klass
    @anonymous_klass ||= Class.new
  end
end


# Arrays

module ArrayFixtures
  extend self

  def blank
    @blank ||= []
  end

  def with_symbol
    @with_symbol ||= [:symbol]
  end

  def with_number
    @with_number ||= [123]
  end

  def with_float
    @with_float ||= [123.456]
  end

  def with_string
    @with_string ||= ['string']
  end

  def with_true
    @with_true ||= [true]
  end

  def with_false
    @with_false ||= [false]
  end

  def with_nil
    @with_nil ||= [nil]
  end

  def deep
    @deep ||= [[[]]]
  end

  def recursive
    @recursive ||= begin
      a = []
      a[0] = a
    end
  end

  def undumpable
    @undumpable ||= [StringIO.new]
  end
end

# Hashes

module HashFixtures
  extend self

  def blank
    @blank ||= {}
  end

  def with_symbols
    @with_symbols ||= { :symbol1 => :symbol2 }
  end

  def with_strings
    @with_strings ||= { 'string1' => 'string 2' }
  end

  def with_numbers
    @with_numbers ||= { 123 => 456 }
  end

  def with_floats
    @with_floats ||= { 12.34 => 56.78 }
  end

  def with_true
    @with_true ||= { true => true }
  end

  def with_false
    @with_false ||= { false => false }
  end

  def with_nil
    @with_nil ||= { nil => nil }
  end

  def deep
    @deep ||= { {} => {} }
  end

  def recursive
    @recursive ||= begin
      h1 = {}
      h1[:self] = h1
    end
  end

  def with_default_proc
    @with_default_proc ||= Hash.new { 0 }
  end
end

def hash_with_default_proc
  @hash_with_default_proc ||= Hash.new { :with_default_block }
end

# MAGIC objects

module MagicFixtures
  MAGIC_DATA = 'MAGIC TEXT'

  class MagicClass
    @magic = MAGIC_DATA
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      BindingDumper::MagicObjects.register(MagicFixtures::MagicClass)
      example.run
    ensure
      BindingDumper::MagicObjects.flush!
    end
  end
end

# Objects

module ObjectFixtures
  extend self

  MyStruct = Struct.new(:value)

  def simple_struct
    @simple_struct ||= MyStruct.new(123)
  end

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

  def undumpable
    @undumpable ||= StringIO.new
  end

  def dumpable
    @dumpable ||= CustomStruct.new(123, 456)
  end

  def partially_dumpable
    @partially_dumpable ||= CustomStruct.new(123, StringIO.new)
  end

  def dumpable_recursive
    @dumpable_recursive ||= begin
      object = CustomRecursiveStruct.allocate
      object.value1 = object
      object.value2 = object
      object
    end
  end

  def undumpable_recursive
    @undumpable_recursive ||= begin
      object = CustomRecursiveStruct.allocate
      object.value1 = object
      object.value2 = StringIO.new
      object
    end
  end
end
