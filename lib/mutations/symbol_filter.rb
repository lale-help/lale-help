module Mutations
  class SymbolFilter < AdditionalFilter
    @default_options = {
      :strip  => true,          # true calls data.strip if data is a string
      :strict => false,         # If false, then symbols, numbers, and booleans are converted to a string with to_s.
      :nils   => false,         # true allows an explicit nil to be valid. Overrides any other options
      :empty  => false,         # false disallows "".  true allows "" and overrides any other validations (b/c they couldn't be true if it's empty)
      :in     => nil            # Can be an array like %i(red blue green)
    }

    def filter(data)

      # Handle nil case
      if data.nil?
        return [nil, nil] if options[:nils]
        return [nil, :nils]
      end

      # Transform it using strip:
      data = data.to_s.strip if options[:strip]

      # Now check if it's blank:
      if data.to_s == ""
        if options[:empty]
          return [nil, nil]
        else
          return [nil, :empty]
        end
      end

      # At this point, data is not nil. If it's not a string, convert it to a string for some standard classes
      data = data.to_sym if !options[:strict] && [TrueClass, FalseClass, Fixnum, Float, BigDecimal, String].include?(data.class)

      # Now ensure it's a symbol:
      return [data, :symbol] unless data.is_a?(Symbol)

      # Ensure it match
      return [data, :in] if options[:in] && !options[:in].include?(data)

      # We win, it's valid!
      [data, nil]
    end
  end
end