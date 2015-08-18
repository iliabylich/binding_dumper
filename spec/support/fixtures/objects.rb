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
