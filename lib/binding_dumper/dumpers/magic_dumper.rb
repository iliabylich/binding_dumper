module BindingDumper
  class Dumpers::MagicDumper < Dumpers::Abstract
    alias_method :object, :abstract_object

    def can_convert?
      MagicObjects.magic?(object)
    end

    def can_deconvert?
      abstract_object.is_a?(Hash) && abstract_object.has_key?(:_magic)
    end

    def convert
      return unless should_convert?

      object_magic = MagicObjects.get_magic(object)
      {
        _magic: object_magic
      }
    end

    def deconvert
      # release magic!
      eval(abstract_object[:_magic])
    end
  end
end
