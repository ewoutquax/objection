class DemoRequires < Objection::Base
  requires :required_1, :required_2
end

class DemoRequiresMore < Objection::Base
  requires :required_3, :required_4
end
