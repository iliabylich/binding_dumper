module BindingDumper
  # Class responsible for converting objects to marshalable Hash
  #
  # @example
  #   o = Object.new
  #   dump = BindingDumper::Dumpers::Array.new(o).convert
  #   # => { marshalable: :hash }
  #   BindingDumper::Dumpers::Array.new(dump).deconvert
  #   # => o
  #
  class Dumpers::ObjectDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @param [Object]
    #
    alias_method :object, :abstract_object

    # Returns true if ObjectDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      true
    end

    # Returns true if ObjectDumper can deconvert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      abstract_object.is_a?(Hash) &&
        (
          abstract_object.has_key?(:_klass) ||
          abstract_object.has_key?(:_object) ||
          abstract_object.has_key?(:_old_object_id)
        )
    end

    # Converts passed +abstract_object+ to marshalable Hash
    #
    # @return [Hash]
    #
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
          _ivars: converted_ivars(dumped_ids),
          _old_object_id: object.object_id
        }
      end
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Object]
    #
    def deconvert
      if object.has_key?(:_object)
        object[:_object]
      else
        klass = object[:_klass]
        result = klass.allocate
        return result if object[:_undumpable]

        yield result

        object[:_ivars].each do |ivar_name, converted_ivar|
          ivar = UniversalDumper.deconvert(converted_ivar)
          result.instance_variable_set(ivar_name, ivar)
        end

        if result.respond_to?(:restored_from_binding)
          result.restored_from_binding
        end

        result
      end
    end

    private

    # Returns converted mapping of instance variables like
    #  { instance variable name => instance variable value }
    #
    # @return [Hash]
    #
    def converted_ivars(dumped_ids = [])
      converted = object.instance_variables.map do |ivar_name|
        ivar = object.instance_variable_get(ivar_name)
        conveted_ivar = UniversalDumper.convert(ivar, dumped_ids)
        [ivar_name, conveted_ivar]
      end.reject(&:empty?)
      Hash[converted]
    end
  end
end
