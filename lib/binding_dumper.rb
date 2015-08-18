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
    autoload :ExistingObjectDumper, 'binding_dumper/dumpers/existing_object_dumper'
  end

  autoload :MagicObjects,    'binding_dumper/magic_objects'
  autoload :UniversalDumper, 'binding_dumper/universal_dumper'
  autoload :CoreExt,         'binding_dumper/core_ext'
end

Binding.send(:include, BindingDumper::CoreExt)
