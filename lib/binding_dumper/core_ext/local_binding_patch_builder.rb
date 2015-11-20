# Class responsible for building patch for local binding
#
# @example
#   data = {
#     file: '/path/to/file.rb',
#     line: 17,
#     method: 'do_something'
#   }
#   patch = BindingDumper::CoreExt::LocalBindingPatchBuilder.new(data).patch
#   patched_binding = binding.extend(patch)
#
#   patched_binding.eval('__FILE__')
#   # => '/path/to/file.rb'
#   patched_binding.eval('__LINE__')
#   # => 17
#   patched_binding.eval('__method__')
#   # => 'do_something'
#
class BindingDumper::CoreExt::LocalBindingPatchBuilder
  # Returns +undumped+ object passed to constructor
  #
  # @return [Hash]
  #
  attr_reader :undumped

  # Takes an undumped object representation
  #
  # @param undumped [Hash]
  #
  def initialize(undumped)
    @undumped = undumped
  end

  # Returns module that is ready for patching existing binding
  #
  # @return [Module]
  #
  def patch
    deps = [
      file_method_patch,
      line_method_patch,
      method_method_patch,
      eval_method_patch
    ]
    Module.new do
      include *deps
    end
  end

  private

  # Returns a module with patch for __FILE__ evaluation
  #
  # @return [Module]
  #
  def file_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_file) { undumped[:file] }
    end
  end

  # Returns a module with patch for __LINE__ evaluation
  #
  # @return [Module]
  #
  def line_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_line) { undumped[:line] }
    end
  end

  # Returns a module with patch for __method__ evaluation
  #
  # @return [Module]
  #
  def method_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_method) { undumped[:method] }
    end
  end

  # Returns a module with patch of 'eval' method, so:
  #  1. __FILE__ returns undumped[:file]
  #  2. __LINE__ returns undumped[:line]
  #  3. __method__ returns undumoed[:method]
  #
  # @return [Module]
  #
  def eval_method_patch
    Module.new do
      define_method :eval do |data, *args|
        case data
        when /__FILE__/
          _file
        when /__LINE__/
          _line
        when /__method__/
          _method
        else
          Binding.instance_method(:eval).bind(self).call(data, *args)
        end
      end
    end
  end
end