require 'bundler/setup'
require 'binding_dumper'
require 'pry'

class A
  def initialize
    @a = 1
  end

  def run
    local = 1
    binding.dump { |dumped| $b = dumped }
  end
end

A.new.run
binding.pry