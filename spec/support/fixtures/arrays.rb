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
