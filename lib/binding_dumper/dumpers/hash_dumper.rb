module BindingDumper
  # Class responsible for converting arbitary hashes to marshalable hashes
  #
  # @example
  #   hash = { key: 'value' }
  #   dump = BindingDumper::Dumpers::HashDumper.new(hash).convert
  #   BindingDumper::Dumpers::HashDumper.new(dump).deconvert
  #   # => { key: 'value' }
  #
  class Dumpers::HashDumper < Dumpers::Abstract
    # An alias to passed +abstract_object+
    #
    # @return [Hash]
    #
    alias_method :hash, :abstract_object

    # Returns true if HashDumper can convert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      hash.is_a?(Hash)
    end

    # Returns true if HashDumper can deconvert passed +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      abstract_object.is_a?(Hash)
    end

    # Converts passed +abstract_object+ to marshalable Hash
    #
    # @return [Hash]
    #
    def convert
      unless should_convert?
        return { _existing_object_id: hash.object_id }
      end

      dumped_ids << hash.object_id

      prepared = hash.map do |k, v|
        converted_k = UniversalDumper.convert(k, dumped_ids)
        converted_v = UniversalDumper.convert(v, dumped_ids)
        [converted_k, converted_v]
      end

      result = Hash[prepared]

      {
        _old_object_id: hash.object_id,
        _object_data: result
      }
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Hash]
    #
    def deconvert
      result = {}
      yield result
      hash.each do |converted_k, converted_v|
        k = UniversalDumper.deconvert(converted_k)
        v = UniversalDumper.deconvert(converted_v)
        result[k] = v
      end
      result
    end
  end
end
