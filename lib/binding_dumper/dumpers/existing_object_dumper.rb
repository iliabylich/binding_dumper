module BindingDumper
  class Dumpers::ExistingObjectDumper < Dumpers::Abstract
    alias_method :hash, :abstract_object

    def can_convert?
      false # really, it's only for deconverting
    end

    def can_deconvert?
      hash.is_a?(Hash) && hash.has_key?(:_existing_object_id)
    end

    def convert
      raise NotImplementedError
    end

    def deconvert
      data_without_object_id = hash.dup.delete(:_existing_object_id)
      # binding.pry
      # object = UniversalDumper.deconvert(data_without_object_id)
      # UniversalDumper.remember!(object)
      # binding.pry
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
