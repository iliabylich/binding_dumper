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
