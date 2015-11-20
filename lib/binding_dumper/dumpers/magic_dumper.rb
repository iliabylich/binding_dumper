module BindingDumper
  # Class responsible for converting 'magical' objects to marshalable hash
  #
  # You should define which objects are 'magical'.
  #  The difference between 'magical' and 'regular' objects is that
  #  'magical' objects are the same for every sessions
  #  like Rails.application.config or Rails.env
  #
  # To make object 'magical', use BindingDumper::MagicObjects.register(object)
  #
  # When you convert a 'magical' object to marshalable hash it returns 'the way how to get it',
  #   not the object itself
  #
  # @example
  #   class A
  #     class << self
  #       @config = :config
  #       attr_reader :config
  #     end
  #   end
  #   BindingDumper::MagicObjects.register(A)
  #   BindingDumper::MagicObjects.pool
  #   {
  #     47472500 => "A",
  #     600668 => "A.instance_variable_get(:@config)"
  #   }
  #   # (the mapping 'object id' => 'the way to get an object')
  #
  #   dump = BindingDumper::Dumpers::MagicDumper.new(A.config).convert
  #   # => { :_magic => "A.instance_variable_get(:@config)" }
  #   restored = BindingDumper::Dumpers::MagicDumper.new(dump).deconvert
  #   # => :config
  #
  class Dumpers::MagicDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @return [Object]
    #
    alias_method :object, :abstract_object

    # Returns true if MagicDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      MagicObjects.magic?(object)
    end

    # Returns true if MagicDumper can deconvert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      abstract_object.is_a?(Hash) && abstract_object.has_key?(:_magic)
    end

    # Converts passed +abstract_object+ to marshalable Hash
    #
    # @return [Hash]
    #
    def convert
      return unless should_convert?

      object_magic = MagicObjects.get_magic(object)
      {
        _magic: object_magic
      }
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Object]
    #
    def deconvert
      # release magic!
      eval(abstract_object[:_magic])
    end
  end
end
