# Class for buliding patch that adds method '_local_binding'
#  to existing object
#
# @example
#   data = {
#     file: '/path/to/file.rb',
#     line: 17,
#     method: 'do_something',
#     lvars: { a: 'b' }
#   }
#   patch = BindingDumper::CoreExt::MagicContextPatchBuilder.new(data).patch
#   context = Object.new.extend(patch)
#
#   context._local_binding
#   # => #<Binding>
#   context._local_binding.eval('a')
#   # => 'b'
#   context._local_binding.eval('__FILE__')
#   # => '/path/to/file.rb'
#   context._local_binding.eval('__LINE__')
#   # => 17
#   context._local_binding.eval('__method__')
#   # => 'do_something'
#
module BindingDumper
  module CoreExt
    class MagicContextPatchBuilder
      # Returns +undupmed+ object passed to constructor
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

      # Returns module that is ready for patching existing context
      #
      # @return [Module]
      #
      def patch
        undumped = self.undumped
        Module.new do
          define_method :_local_binding do
            result = binding

            undumped[:lvars].each do |lvar_name, lvar|
              result.eval("#{lvar_name} = ObjectSpace._id2ref(#{lvar.object_id})")
            end

            mod = LocalBindingPatchBuilder.new(undumped).patch
            result.extend(mod)
          end
        end
      end
    end
  end
end
