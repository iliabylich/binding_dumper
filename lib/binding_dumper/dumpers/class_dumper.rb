module BindingDumper
  # Class responsible for converting classes to marshalable Hash
  #
  # @example
  #   class MyClass
  #     @a = 1
  #     @@b = 2
  #   end
  #   dump = BindingDumper::Dumpers::ClassDumper.new(MyClass).convert
  #   # => { marshalable: :hash }
  #   BindingDumper::Dumpers::ClassDumper.new(MyClass).deconvert
  #   # => MyClass
  #
  class Dumpers::ClassDumper < Dumpers::Abstract
    alias_method :klass, :abstract_object

    # Returns +true+ if ClassDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      klass.is_a?(Class)
    end

    # Returns +true+ if ClassDumper can deconvert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      abstract_object.is_a?(Hash) &&
        (abstract_object.has_key?(:_cvars) || abstract_object.has_key?(:_anonymous))
    end

    # Converts passed +abstract_object+ to marshalable Hash
    #
    # @return [Hash]
    #
    def convert
      return unless should_convert?
      dumped_ids << klass.object_id

      if klass.name
        {
          _klass: klass,
          _ivars: converted_ivars(dumped_ids),
          _cvars: converted_cvars(dumped_ids)
        }
      else
        {
          _anonymous: true
        }
      end

    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Class]
    #
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

    # Returns converted mapping of instance variables like
    #  { instance variable name => instance variable value }
    #
    # @return [Hash]
    #
    def converted_ivars(dumped_ids = [])
      converted = klass.instance_variables.map do |ivar_name|
        ivar = klass.instance_variable_get(ivar_name)
        conveted_ivar = UniversalDumper.convert(ivar, dumped_ids)
        [ivar_name, conveted_ivar]
      end
      Hash[converted]
    end

    # Returns converted mapping of class variables like
    #  { class variable name => class variable vakue }
    #
    # @return [Hash]
    #
    def converted_cvars(dumped_ids = [])
      converted = klass.class_variables.map do |cvar_name|
        ivar = klass.class_variable_get(cvar_name)
        if dumped_ids.include?(ivar.object_id)
          []
        else
          conveted_ivar = UniversalDumper.convert(ivar, dumped_ids)
          [cvar_name, conveted_ivar]
        end
      end
      Hash[converted]
    end
  end
end
