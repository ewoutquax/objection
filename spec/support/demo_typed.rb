class DemoTyped < Objection::Base
  requires :required_1, :required_2
  optionals :optional_1, :optional_2
  input_types(
    required_1: Fixnum,
    required_2: String,
    optional_1: Float
  )
end
