require "binding_dumper/version"

module BindingDumper
  module Dumpers
    autoload :Abstract, 'binding_dumper/dumpers/abstract'
    autoload :PrimitiveDumper, 'binding_dumper/dumpers/primitive_dumper'
    autoload :ArrayDumper, 'binding_dumper/dumpers/array_dumper'
    autoload :HashDumper, 'binding_dumper/dumpers/hash_dumper'
    autoload :ObjectDumper, 'binding_dumper/dumpers/object_dumper'
    autoload :ClassDumper, 'binding_dumper/dumpers/class_dumper'
    autoload :ProcDumper, 'binding_dumper/dumpers/proc_dumper'
    autoload :MagicDumper, 'binding_dumper/dumpers/magic_dumper'
  end

  autoload :MagicObjects,    'binding_dumper/magic_objects'
  autoload :UniversalDumper, 'binding_dumper/universal_dumper'
end


module BindingDumper
  module CoreExt
    def dump(&block)
      context = eval('self')
      data_to_dump = {
        context: context,
        method: eval('__method__'),
        file: eval('__FILE__'),
        line: eval('__LINE__'),
        lvars: {}
      }
      local_variables.each do |lvar_name|
        data_to_dump[:lvars][lvar_name] = local_variable_get(lvar_name)
      end
      dumped = BindingDumper::UniversalDumper.dump(data_to_dump)
      block.call(dumped)
    end

    def self.included(base)
      def base.load(dumped)
        undumped = BindingDumper::UniversalDumper.load(dumped)

        context = undumped[:context]

        context.singleton_class.send(:define_method, :_local_binding) do
          result = binding

          undumped[:lvars].each do |lvar_name, lvar|
            result.local_variable_set(lvar_name, lvar)
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

Binding.send(:include, BindingDumper::CoreExt)
