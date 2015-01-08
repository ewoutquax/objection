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
    def self.input_types(*args)
      @input_types = args[0]
      true
    end

    def initialize(*args)
      @values = normalize_input(*args)

      check_values!
      define_accessors
      apply_structures!
      check_types!
    end

    def to_hash
      hash = {}
      @values.each_pair do |key, value|
        if value.is_a?(Array)
          hash[key] = value.inject([]) do |items, item|
            items << item.to_hash
          end
        elsif value.respond_to?(:to_hash)
          hash[key] = value.to_hash
        else
          hash[key] = value
        end
      end
      hash
    end

    private
      def define_accessors
        known_fields.each{|field| define_getter(field)}
        optional_fields.each{|field| define_optional_setter(field)}
        required_fields.each{|field| define_required_setter(field)}
      end

      def check_values!
        raise UnknownFieldGiven, unknown_fields.join(', ')             if unknown_fields_present?
        raise RequiredFieldMissing, missing_required_fields.join(', ') if missing_required_fields?
        raise RequiredFieldEmpty, blank_required_fields.join(', ')     if blank_required_fields?
      end

      def apply_structures!
        input_types.each do |field, type|
          value = self.send(field)
          if !value.is_a?(type) && value.is_a?(Hash)
            @values[field] = type.new(value)
          end
          if !value.is_a?(type) && value.is_a?(Array)
            values = []
            value.each do |item|
              values << type.new(item)
            end
            @values[field] = values
          end
        end
      end

      def check_types!
        input_types.each do |field, type|
          value = self.send(field)
          unless value.nil?
            if !(value.is_a?(type) || value.is_a?(Array))
              raise TypeError, "#{field} has the wrong type; #{type} was expected, but got #{value.class}"
            end
          end
        end
      end

      def define_getter(fieldname)
        self.class.send(:define_method, "#{fieldname}") do
          @values[fieldname]
        end
      end

      def define_optional_setter(fieldname)
        self.class.send(:define_method, "#{fieldname}=") do |arg|
          @values[fieldname] = arg
          check_types!
        end
      end

      def define_required_setter(fieldname)
        self.class.send(:define_method, "#{fieldname}=") do |arg|
          raise RequiredFieldMadeEmpty, fieldname if arg.nil? || arg == ''
          @values[fieldname] = arg
          check_types!
        end
      end

      def normalize_input(*args)
        if args.any? && args[0].is_a?(Hash)
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
          value = @values[field]
          value == '' || value.nil?
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

      def input_types
        self.class.instance_variable_get('@input_types') || {}
      end
  end
end
