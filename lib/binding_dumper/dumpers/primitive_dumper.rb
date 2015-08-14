module BindingDumper
  class Dumpers::PrimitiveDumper < Dumpers::Abstract
    alias_method :primitive, :abstract_object

    SUPPORTED_CLASSES = [
      Numeric,
      String,
      NilClass,
      FalseClass,
      TrueClass,
      Symbol
    ]

    def can_convert?
      SUPPORTED_CLASSES.any? do |klass|
        abstract_object.is_a?(klass)
      end
    end

    def can_deconvert?
      true
    end

    def convert
      primitive
    end

    def deconvert
      primitive
    end
  end
end
