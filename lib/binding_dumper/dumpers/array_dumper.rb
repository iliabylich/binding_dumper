module BindingDumper
  # Class responsible for converting arrays to marshalable Hash
  #
  # @example
  #   array = [1,2,3]
  #   dump = BindingDumper::Dumpers::Array.new(array).convert
  #   # => { marshalable: :hash }
  #   BindingDumper::Dumpers::Array.new(dump).deconvert
  #   # => [1,2,3]
  #
  class Dumpers::ArrayDumper < Dumpers::Abstract
    alias_method :array, :abstract_object

    # Returns true if ArrayDumper can convert +abstract_object+
    #
    # @return [true, false]
    #
    def can_convert?
      array.is_a?(Array)
    end

    # Returns true if ArrayDumper can deconvert +abstract_object+
    #
    # @return [true, false]
    #
    def can_deconvert?
      array.is_a?(Array)
    end

    # Converts +abstract_object+ to marshalable Hash
    #
    # @return [Hash]
    #
    def convert
      unless should_convert?
        return { _existing_object_id: array.object_id }
      end

      dumped_ids << array.object_id

      result = array.map do |item|
        UniversalDumper.convert(item, dumped_ids)
      end

      {
        _old_object_id: array.object_id,
        _object_data: result
      }
    end

    # Deconverts passed +abstract_object+ back to the original state
    #
    # @return [Array]
    #
    def deconvert
      result = []
      yield result
      array.each do |converted_item|
        result << UniversalDumper.deconvert(converted_item)
      end
      result
    end
  end
end
