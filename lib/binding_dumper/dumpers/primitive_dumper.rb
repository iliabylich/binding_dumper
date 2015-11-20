module BindingDumper
  # Class responsible for converting primitive objects to marshalable hash
  #
  # @see SUPPORTED_CLASSES
  #
  class Dumpers::PrimitiveDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @return [Object]
    #
    alias_method :primitive, :abstract_object

    SUPPORTED_CLASSES = [
      Numeric,
      String,
      NilClass,
      FalseClass,
      TrueClass,
      Symbol
    ]

    # Returns true if PrimitiveDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      SUPPORTED_CLASSES.any? do |klass|
        abstract_object.is_a?(klass)
      end
    end

    def can_deconvert?
      true
    end

    # Returns +abstract_object+
    #
    # @return [Object]
    #
    def convert
      primitive
    end

    # Returns +abstract_object+
    #
    # @return [Object]
    #
    def deconvert
      primitive
    end
  end
end
