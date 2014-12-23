require "objection/version"

module Objection
  class Base
    class ObjectionException     < Exception; end
    class RequiredFieldsMissing  < ObjectionException; end
    class RequiredFieldMadeEmpty < ObjectionException; end
    class UnknownFieldGiven      < ObjectionException; end

    def self.requires(*args)
      @required_fields = args
    end
    def self.optionals(*args)
      @optional_fields = args
    end

    def initialize(*args)
      # raise RequiredFieldsMissing, ':required_1, :required_2' unless required_fields.nil?
      @values = normalize_input(*args)
    end

    def method_missing(method, *args)
      if method[-1] == '='
        field = method[0..-2].to_sym
        unless known_field?(field)
          raise UnknownFieldGiven, field
        end
        if required_field?(field) && (args[0] == '' || args[0].nil?)
          raise RequiredFieldMadeEmpty, field
        end
        @values[field] = args[0]
      else
        @values[method]
      end
    end

    private
      def normalize_input(*args)
        if args.any?
          args[0].inject({}) do |out, (key, value)|
            out.merge(key.to_sym => value)
          end
        else
          {}
        end
      end

      def known_fields
        required_fields + optional_fields
      end

      def known_field?(field)
        known_fields.include?(field)
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

      def required_field?(field)
        required_fields.include?(field)
      end

      def required_fields
        self.class.instance_variable_get('@required_fields') || []
      end

      def optional_fields
        self.class.instance_variable_get('@optional_fields') || []
      end
  end
end
