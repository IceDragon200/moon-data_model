module Moon
  module DataModel
    # Utility module for formatting debug context information
    module MessageFormat
      # Formats an error message to add more contextual info
      #
      # @param [String] msg
      # @param [Hash<Symbol, Object>] ctx
      # @option ctx [Symbol] :key
      # @option ctx [String] :prefix
      # @return [String]
      def format_err(msg, ctx = {})
        result = msg.dup
        if ctx
          if k = ctx[:key]
            result = "#{k.inspect} #{result}"
          end
          if p = ctx[:prefix]
            result = "#{prefix}: #{result}"
          end
        end
        result
      end
    end
  end
end
