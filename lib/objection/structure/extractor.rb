module Objection
  module Structure
    class Extractor
      def self.extract(input_hash)
        input_hash.inject([]) do |out, (key_string, value)|
          key = key_string.to_sym
          if value.is_a?(Hash)
            out << {key => self.extract(value)}
          else
            out << key
          end
        end
      end
    end
  end
end
