class BindingDumper::Dumpers::ClassDumper < BindingDumper::Dumpers::Abstract
  alias_method :klass, :abstract_object

  def convert
    return unless should_convert?
    new_dumped_ids = dumped_ids + [klass.object_id]

    if klass.name
      {
        _klass: klass,
        _ivars: converted_ivars(dumped_ids: new_dumped_ids),
        _cvars: converted_cvars(dumped_ids: new_dumped_ids)
      }
    else
      {
        _anonymous: true
      }
    end

  end

  def deconvert
    return Class.new if abstract_object[:_anonymous]
    klass, converted_ivars, converted_cvars = abstract_object[:_klass], abstract_object[:_ivars], abstract_object[:_cvars]

    converted_ivars.each do |ivar_name, converted_ivar|
      ivar = UniversalDumper.deconvert(converted_ivar)
      klass.instance_variable_set(ivar_name, ivar)
    end

    converted_cvars.each do |cvar_name, converted_cvar|
      cvar = UniversalDumper.deconvert(converted_cvar)
      klass.class_variable_set(cvar_name, cvar)
    end

    klass
  end

  private

  def converted_ivars(dumped_ids: [])
    converted = klass.instance_variables.map do |ivar_name|
      ivar = klass.instance_variable_get(ivar_name)
      if dumped_ids.include?(ivar.object_id)
        []
      else
        conveted_ivar = UniversalDumper.convert(ivar, dumped_ids: dumped_ids)
        [ivar_name, conveted_ivar]
      end
    end
    Hash[converted]
  end

  def converted_cvars(dumped_ids: [])
    converted = klass.class_variables.map do |cvar_name|
      ivar = klass.class_variable_get(cvar_name)
      if dumped_ids.include?(ivar.object_id)
        []
      else
        conveted_ivar = UniversalDumper.convert(ivar, dumped_ids: dumped_ids)
        [cvar_name, conveted_ivar]
      end
    end
    Hash[converted]
  end
end
