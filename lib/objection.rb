require "objection/version"

module Objection
  class Base
    def requires
    end
    def optionals
    end
    def required_fields
      [:required_1, :required_2]
    end
  end
end
