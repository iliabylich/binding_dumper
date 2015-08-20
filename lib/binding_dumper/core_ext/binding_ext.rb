module BindingDumper
  module CoreExt
    module BindingExt
      def lvars_to_dump
        eval('local_variables').each_with_object({}) do |lvar_name, result|
          result[lvar_name] = eval(lvar_name.to_s)
        end
      end

      def data_to_dump
        context = eval('self')
        result = {
          context: context,
          method: eval('__method__'),
          file: eval('__FILE__'),
          line: eval('__LINE__'),
          lvars: lvars_to_dump
        }
      end

      def dump(&block)
        dumped = UniversalDumper.dump(data_to_dump)
        block.call(dumped) if block_given?
        dumped
      end

      module ClassMethods
        def load(dumped)
          undumped = UniversalDumper.load(dumped)

          mod = MagicContextPatchBuilder.new(undumped).patch

          undumped[:context].extend(mod)._local_binding
        end
      end
    end
  end
end
