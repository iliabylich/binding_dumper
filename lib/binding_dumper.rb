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
  end
end



module UniversalDumper
  DUMPERS = {
    Array      => BindingDumper::Dumpers::ArrayDumper,
    Hash       => BindingDumper::Dumpers::HashDumper,
    Proc       => BindingDumper::Dumpers::ProcDumper,
    Method     => BindingDumper::Dumpers::ProcDumper,
    Class      => BindingDumper::Dumpers::ClassDumper,
    Numeric    => BindingDumper::Dumpers::PrimitiveDumper,
    String     => BindingDumper::Dumpers::PrimitiveDumper,
    NilClass   => BindingDumper::Dumpers::PrimitiveDumper,
    FalseClass => BindingDumper::Dumpers::PrimitiveDumper,
    TrueClass  => BindingDumper::Dumpers::PrimitiveDumper,
    Symbol     => BindingDumper::Dumpers::PrimitiveDumper
  }
  DEFAULT_DUMPER = BindingDumper::Dumpers::ObjectDumper

  extend self

  def dumper_for(object)
    dumper = DUMPERS.detect do |klass, dumper_klass|
      object.is_a?(klass)
    end
    dumper ? dumper.last : DEFAULT_DUMPER
  end

  def convert(object, dumped_ids: [])
    dumper_for(object).new(object, dumped_ids: dumped_ids).convert
  end

  def dump(object)
    converted = convert(object)
    Marshal.dump(converted)
  end

  def deconverter_for(data)
    if data.is_a?(Hash) && data.has_key?(:_source)
      BindingDumper::Dumpers::ProcDumper
    elsif data.is_a?(Hash) && (data.has_key?(:_cvars) || data.has_key?(:_anonymous))
      BindingDumper::Dumpers::ClassDumper
    elsif data.is_a?(Hash) && (data.has_key?(:_klass) || data.has_key?(:_object))
      BindingDumper::Dumpers::ObjectDumper
    elsif data.is_a?(Hash)
      BindingDumper::Dumpers::HashDumper
    elsif data.is_a?(Array)
      BindingDumper::Dumpers::ArrayDumper
    else
      BindingDumper::Dumpers::PrimitiveDumper
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
