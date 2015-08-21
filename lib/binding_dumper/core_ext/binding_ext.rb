# Module with patches for Binding class
#
# @example
#  dump = binding.dump
#  # => 'string representation of binding'
#  Binding.load(dump)
#  # => #<Binding>
#
module BindingDumper
  module CoreExt
    module BindingExt

      # Returns mapping
      #  { local variable name => local variable }
      #
      # @return [Hash]
      #
      def lvars_to_dump
        eval('local_variables').each_with_object({}) do |lvar_name, result|
          result[lvar_name] = eval(lvar_name.to_s)
        end
      end

      # Returns all the data that represents a context
      #  (including context, local variables, file, line and method name)
      #
      # @return [Hash]
      #
      def data_to_dump
        context = eval('self')
        result = {
          context: context,
          method: eval('__method__'),
          file: eval('__FILE__'),
          line: eval('__LINE__'),
          lvars: lvars_to_dump
        }
      end

      # Dumps a binding and returns a dump
      #
      # @return [String]
      #
      # @yield [String] (if block given)
      #
      def dump(&block)
        dumped = UniversalDumper.dump(data_to_dump)
        block.call(dumped) if block_given?
        dumped
      end

      module ClassMethods
        # Loads a binding from dump
        #
        # @return [Binding]
        #
        def load(dumped)
          undumped = UniversalDumper.load(dumped)

          mod = MagicContextPatchBuilder.new(undumped).patch

          undumped[:context].extend(mod)._local_binding
        end
      end
    end
  end
end
