module BindingDumper
  module CoreExt
    class MagicContextPatchBuilder
      attr_reader :undumped

      def initialize(undumped)
        @undumped = undumped
      end

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
