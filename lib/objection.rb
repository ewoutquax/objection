require "objection/version"

module Objection
  class Base
    class ObjectionException   < Exception; end
    class RequiredFieldMissing < ObjectionException; end
    class RequiredFieldEmpty   < ObjectionException; end
    class UnknownFieldGiven    < ObjectionException; end

    def self.requires(*args)
      @required_fields = args
    end
    def self.optionals(*args)
      @optional_fields = args
    end

    def initialize(*args)
      @values = normalize_input(*args)

      if unknown_fields_present?
        raise UnknownFieldGiven, unknown_fields.join(', ')
      end
      if missing_required_fields?
        raise RequiredFieldMissing, missing_required_fields.join(', ')
      end
      if blank_required_fields?
        raise RequiredFieldEmpty, blank_required_fields.join(', ')
      end
    end

    def method_missing(method, *args)
      if method[-1] == '='
        field = method[0..-2].to_sym
        unless known_field?(field)
          raise UnknownFieldGiven, field
        end
        if required_field?(field) && (args[0] == '' || args[0].nil?)
          raise RequiredFieldEmpty, field
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

      def unknown_fields_present?
        unknown_fields.any?
      end

      def unknown_fields
        present_fields - known_fields
      end

      def blank_required_fields?
        blank_required_fields.any?
      end

      def blank_required_fields
        required_fields.select do |field|
          @values[field] == '' || @values[field].nil?
        end
      end

      def missing_required_fields?
        missing_required_fields.any?
      end

      def missing_required_fields
        required_fields - present_fields
      end

      def required_field?(field)
        required_fields.include?(field)
      end

      def present_fields
        @values.keys
      end

      def required_fields
        self.class.instance_variable_get('@required_fields') || []
      end

      def optional_fields
        self.class.instance_variable_get('@optional_fields') || []
      end
  end
end
