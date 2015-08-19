module BindingDumper
  module CoreExt
    def lvars_to_dump
      self.eval('local_variables').each_with_object({}) do |lvar_name, result|
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

    def self.included(base)
      def base.load(dumped)
        undumped = UniversalDumper.load(dumped)

        context = undumped[:context]

        context.singleton_class.send(:define_method, :_local_binding) do
          result = binding

          undumped[:lvars].each do |lvar_name, lvar|
            result.eval("#{lvar_name} = ObjectSpace._id2ref(#{lvar.object_id})")
          end

          m = Module.new do
            define_method(:_file) { undumped[:file] }
            define_method(:_line) { undumped[:line] }
            define_method(:_method) { undumped[:method] }
            def eval(data, *args)
              case data
              when /__FILE__/
                _file
              when /__LINE__/
                _line
              when /__method__/
                _method
              else
                super
              end
            end
          end
          (class << result; self; end).send(:prepend, m)
          result
        end

        context._local_binding
      end
    end
  end
end
