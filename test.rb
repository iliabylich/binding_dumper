require 'bundler/setup'
require 'binding_dumper'
require 'pry'

class A
  def initialize
    @a = "IVAR A"
  end

  def run
    local = "LOCAL"
    binding.dump { |dumped| $b = dumped }
  end
end

A.new.run
Binding.load($b).pry
