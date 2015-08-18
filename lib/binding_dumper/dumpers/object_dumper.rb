module BindingDumper
  class Dumpers::ObjectDumper < Dumpers::Abstract
    alias_method :object, :abstract_object

    def can_convert?
      true
    end

    def can_deconvert?
      abstract_object.is_a?(Hash) &&
        (
          abstract_object.has_key?(:_klass) ||
          abstract_object.has_key?(:_object) ||
          abstract_object.has_key?(:_old_object_id)
        )
    end

    def convert
      unless should_convert?
        return { _existing_object_id: object.object_id }
      end

      if can_be_fully_dumped?(object)
        {
          _object: object
        }
      elsif undumpable?(object)
        {
          _klass: object.class,
          _undumpable: true
        }
      else
        dumped_ids << object.object_id
        {
          _klass: object.class,
          _ivars: converted_ivars(dumped_ids: dumped_ids),
          _old_object_id: object.object_id
        }
      end
    end

    def deconvert
      if object.has_key?(:_object)
        object[:_object]
      else
        klass = object[:_klass]
        result = klass.allocate
        return result if object[:_undumpable]

        object[:_ivars].each do |ivar_name, converted_ivar|
          ivar = UniversalDumper.deconvert(converted_ivar)
          result.instance_variable_set(ivar_name, ivar)
        end
        result
      end
    end

    private

    def converted_ivars(dumped_ids: [])
      converted = object.instance_variables.map do |ivar_name|
        ivar = object.instance_variable_get(ivar_name)
        conveted_ivar = UniversalDumper.convert(ivar, dumped_ids: dumped_ids)
        [ivar_name, conveted_ivar]
      end.reject(&:empty?)
      Hash[converted] rescue binding.pry
    end
  end
end
