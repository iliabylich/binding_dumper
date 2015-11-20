module BindingDumper
  # Class responsible for restoring recurring objects
  #
  # If you dump an object twice you will get:
  #  First time:  { marshalable: :hash }
  #  Second time: { _existing_object_id: 1234 }
  #
  # This _existing_object_id is actually an object_id of dumped object
  #  in original memory
  #
  # So, after deconverting the hash { _existing_object_id: ojbect_id }
  #  You will get an object from your current memory
  #
  # @example
  #   class Profile
  #     attr_accessor :first_name, :last_name
  #   end

  #   profile = Profile.allocate
  #   profile.first_name = profile     # <-- so the object is recursive
  #   profile.last_name = StringIO.new # <-- and unmarshalable
  #   dump = BindingDumper::UniversalDumper.convert(profile)
  #   =>
  #   {
  #     :_klass => Profile,
  #     :_ivars => {
  #       :@first_name => {
  #         :_existing_object_id => 47687640 # <-- right here
  #       },
  #       :@last_name => {
  #         :_klass => StringIO,
  #         :_undumpable => true
  #       }
  #     },
  #     :_old_object_id => 47687640
  #   }
  #
  #   restored = BindingDumper::UniversalDumper.deconvert(profile)
  #   restored.profile.equal?(restored)
  #   # => true # (they have the same object id)
  #
  class Dumpers::ExistingObjectDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @return [Hash]
    #
    alias_method :hash, :abstract_object

    # Returns false, this class is only for deconverting
    #
    def can_convert?
      false # really, it's only for deconverting
    end

    # Returns true if ExistingObjectDumper can deconvert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      hash.is_a?(Hash) && hash.has_key?(:_existing_object_id)
    end

    # Raises an exception, don't use this class for converting
    #
    # @raise [NotImplementedError]
    #
    def convert
      raise NotImplementedError
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Object]
    #
    # @raise [RuntimeError] when object doesn't exist in the memory
    #
    def deconvert
      data_without_object_id = hash.dup.delete(:_existing_object_id)

      unless UniversalDumper.memories.has_key?(existing_object_id)
        raise "Object with id #{existing_object_id} wasn't dumped. Something is wrong."
      end

      UniversalDumper.memories[existing_object_id]
    end

    private

    def existing_object_id
      hash[:_existing_object_id]
    end
  end
end
