require "objection/version"

module Objection
  class Base
    class ObjectionException     < Exception; end
    class RequiredFieldMissing   < ObjectionException; end
    class RequiredFieldEmpty     < ObjectionException; end
    class RequiredFieldMadeEmpty < ObjectionException; end
    class UnknownFieldGiven      < ObjectionException; end

    def self.requires(*args)
      @required_fields = args
    end
    def self.optionals(*args)
      @optional_fields = args
    end

    def initialize(*args)
      @values = normalize_input(*args)

      define_accessors

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

    private
      def define_accessors
        known_fields.each{|field| define_getter(field.to_s)}
        optional_fields.each{|field| define_optional_setter(field.to_s)}
        required_fields.each{|field| define_required_setter(field.to_s)}
      end

      def define_getter(fieldname)
        self.class.send(:define_method, fieldname) do
          @values[fieldname.to_sym]
        end
      end

      def define_optional_setter(fieldname)
        self.class.send(:define_method, "#{fieldname}=") do |arg|
          @values[fieldname.to_sym] = arg
        end
      end

      def define_required_setter(fieldname)
        self.class.send(:define_method, "#{fieldname}=") do |arg|
          raise RequiredFieldMadeEmpty, fieldname if arg.nil? || arg == ''
          @values[fieldname.to_sym] = arg
        end
      end

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
