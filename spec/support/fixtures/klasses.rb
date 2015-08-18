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
