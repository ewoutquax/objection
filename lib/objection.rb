require "objection/version"

module Objection
  class Base
    class ObjectionException    < Exception; end
    class RequiredFieldsMissing < ObjectionException; end


    def self.requires(*args)
      @required_fields = args
    end
    def self.optionals(*args)
      @optional_fields = args
    end

    def initialize(*args)
      raise RequiredFieldsMissing, ':required_1, :required_2' unless required_fields.nil?
    end

    private
      def known_fields
        required_fields + optional_fields
      end

      def unknown_fields_present?(array_fields)
        unknown_fields(array_fields).any?
      end

      def unknown_fields(array_fields)
        array_fields - known_fields
      end

      def missing_required_fields(array_fields)
        required_fields - array_fields
      end

      def required_fields
        self.class.instance_variable_get('@required_fields')
      end

      def optional_fields
        self.class.instance_variable_get('@optional_fields')
      end
  end
end
