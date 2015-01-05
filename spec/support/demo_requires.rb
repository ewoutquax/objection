class DemoRequires < Objection::Base
  requires :required_1, :required_2
end

class DemoRequiresMore < Objection::Base
  requires :required_3, :required_4
end

class DemoRequiresStructure < Objection::Base
  requires :required_5, required_6: [:required_6_1]
end
