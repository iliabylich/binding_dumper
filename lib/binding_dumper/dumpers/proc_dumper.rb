module BindingDumper
  # Class responsible for converting procs and methods to marshalable hash
  #
  # It uses a gem called 'method_source' which may inspect the source of proc/method
  #
  class Dumpers::ProcDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @return [Proc]
    #
    alias_method :_proc, :abstract_object

    # Returns true if ProcDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      _proc.is_a?(Proc) || _proc.is_a?(Method)
    end

    # Returns true if ProcDumper can deconvert pased +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      abstract_object.is_a?(Hash) && abstract_object.has_key?(:_source)
    end

    # Converts passed +abstract_object+ to marshalable hash
    #
    # @return [Hash]
    #
    def convert
      return unless should_convert?

      source = (_proc.to_proc.source rescue 'proc {}').strip
      { _source: source }
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Object]
    #
    def deconvert
      eval(_proc[:_source]) rescue proc {}
    end
  end
end
