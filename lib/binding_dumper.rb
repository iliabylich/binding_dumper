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

  autoload :MagicObjects, 'binding_dumper/magic_objects'
end



module UniversalDumper
  DUMPERS_ON_CONVERTING = [
    BindingDumper::Dumpers::MagicDumper,
    BindingDumper::Dumpers::ProcDumper,
    BindingDumper::Dumpers::ClassDumper,
    BindingDumper::Dumpers::ArrayDumper,
    BindingDumper::Dumpers::HashDumper,
    BindingDumper::Dumpers::PrimitiveDumper,
    BindingDumper::Dumpers::ObjectDumper
  ]

  DUMPERS_ON_DECONVERTING = [
    BindingDumper::Dumpers::MagicDumper,
    BindingDumper::Dumpers::ProcDumper,
    BindingDumper::Dumpers::ArrayDumper,
    BindingDumper::Dumpers::ClassDumper,
    BindingDumper::Dumpers::ObjectDumper,
    BindingDumper::Dumpers::HashDumper,
    BindingDumper::Dumpers::PrimitiveDumper
  ]

  extend self

  def converter_for(object)
    DUMPERS_ON_CONVERTING.detect do |dumper_klass|
      dumper_klass.new(object).can_convert?
    end
  end

  def convert(object, dumped_ids: [])
    converter_for(object).new(object, dumped_ids: dumped_ids).convert
  end

  def dump(object)
    converted = convert(object)
    Marshal.dump(converted)
  end

  def deconverter_for(object)
    DUMPERS_ON_DECONVERTING.detect do |dumper_klass|
      dumper_klass.new(object).can_deconvert?
    end
  end

  def deconvert(converted_data)
    deconverter = deconverter_for(converted_data)
    deconverter.new(converted_data).deconvert
  end

  def load(object)
    converted = Marshal.load(object)
    deconvert(converted)
  end
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
      dumped = UniversalDumper.dump(data_to_dump)
      block.call(dumped)
    end

    def self.included(base)
      def base.load(dumped)
        undumped = UniversalDumper.load(dumped)

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
