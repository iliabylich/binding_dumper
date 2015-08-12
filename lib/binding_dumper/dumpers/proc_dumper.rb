class BindingDumper::Dumpers::ProcDumper < BindingDumper::Dumpers::Abstract
  alias_method :_proc, :abstract_object

  def convert
    return unless should_convert?

    source = (_proc.to_proc.source rescue 'proc {}').strip
    { _source: source }
  end

  def deconvert
    eval(_proc[:_source]) rescue proc {}
  end
end
