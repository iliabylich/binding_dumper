require 'bundler/setup'
require 'binding_dumper'
require 'pry'

class A
  def initialize
    @a = "IVAR A"
  end

  def run
    local = "LOCAL"
    $b = binding.dump
  end
end

A.new.run
Binding.load($b).pry
