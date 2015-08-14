module BindingDumper
  class Dumpers::ProcDumper < Dumpers::Abstract
    alias_method :_proc, :abstract_object

    def can_convert?
      _proc.is_a?(Proc) || _proc.is_a?(Method)
    end

    def can_deconvert?
      abstract_object.is_a?(Hash) && abstract_object.has_key?(:_source)
    end

    def convert
      return unless should_convert?

      source = (_proc.to_proc.source rescue 'proc {}').strip
      { _source: source }
    end

    def deconvert
      eval(_proc[:_source]) rescue proc {}
    end
  end
end
