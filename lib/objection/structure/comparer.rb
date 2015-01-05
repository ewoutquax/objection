module Objection
  module Structure
    class Comparer
      def initialize(structure_base)
        @base = structure_base
      end

      def missing_fields(structure_compare)
        @base - structure_compare
      end

      def unknown_fields(structure_compare)
        structure_compare - @base
      end
    end
  end
end
