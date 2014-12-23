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

    def required_fields
      self.class.instance_variable_get('@required_fields')
    end

    def optional_fields
      self.class.instance_variable_get('@optional_fields')
    end

    def initialize(*args)
      raise RequiredFieldsMissing, ':required_1, :required_2' unless required_fields.nil?
    end

    class << self
      attr_accessor :required_fields
    end
  end
end
