class BindingDumper::Dumpers::PrimitiveDumper < BindingDumper::Dumpers::Abstract
  alias_method :primitive, :abstract_object

  def convert
    primitive
  end

  def deconvert
    primitive
  end
end
