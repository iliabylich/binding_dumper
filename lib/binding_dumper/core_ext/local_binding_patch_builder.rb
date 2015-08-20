class BindingDumper::CoreExt::LocalBindingPatchBuilder
  attr_reader :undumped

  def initialize(undumped)
    @undumped = undumped
  end

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

  def file_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_file) { undumped[:file] }
    end
  end

  def line_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_line) { undumped[:line] }
    end
  end

  def method_method_patch
    undumped = self.undumped
    Module.new do
      define_method(:_method) { undumped[:method] }
    end
  end

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