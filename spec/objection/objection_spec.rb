require_relative '../spec_helper'
require_relative '../support/demo_basic'
require_relative '../support/demo_requires'
require_relative '../support/demo_optionals'
require_relative '../support/demo_typed'
require_relative '../support/demo_nested'

describe Objection do
  before do
    Objection::Base.instance_variable_set('@required_fields', nil)
  end

  context 'base' do
    it 'can instantiate the class' do
      expect(Objection::Base.new).to be_kind_of(Objection::Base)
    end
    it 'can find the requires-function' do
      expect(Objection::Base.respond_to?(:requires)).to eq(true)
    end
    it 'can find the optionals-function' do
      expect(Objection::Base.respond_to?(:optionals)).to eq(true)
    end
  end

  context 'required_fields' do
    let(:object) { build_object_for_required_fields }

    it 'can be defined and fetched' do
      obj = DemoRequires.new(required_1: 'dummy', required_2: 'dummy')
      obj_more = DemoRequiresMore.new(required_3: 'dummy', required_4: 'dummy')

      expect(obj.send(:required_fields)).to eq([:required_1, :required_2])
      expect(obj_more.send(:required_fields)).to eq([:required_3, :required_4])
    end

    it 'builds a list of missing required fields' do
      expect(object).to receive(:present_fields).and_return([:field_1])
      result = object.send(:missing_required_fields)
      expect(result).to eq([:field_2])
    end

    it 'can be changed after initialization' do
      object.field_1 = 'new value'
      expect(object.field_1).to eq('new value')
    end

    it 'raises an error, when a required field is blanked' do
      expect{object.field_1 = ''}.to raise_error(Objection::Base::RequiredFieldMadeEmpty, 'field_1')
      expect{object.field_2 = nil}.to raise_error(Objection::Base::RequiredFieldMadeEmpty, 'field_2')
    end

    def build_object_for_required_fields
      obj = Objection::Base.new
      obj.class.instance_variable_set('@required_fields', [:field_1, :field_2])
      obj.send(:define_accessors)
      obj
    end
  end

  context 'optional_fields' do
    it 'can be defined and fetched' do
      obj = DemoOptionals.new
      obj_more = DemoOptionalsMore.new

      expect(obj).to be_kind_of(DemoOptionals)
      expect(obj).to be_kind_of(Objection::Base)
      expect(obj.send(:optional_fields)).to eq([:optional_1, :optional_2])
      expect(obj_more.send(:optional_fields)).to eq([:optional_3, :optional_4])
    end

    it 'can be changed after initialization' do
      obj = DemoOptionals.new
      obj.optional_1 = 'value_1'
      expect(obj.optional_1).to eq('value_1')
    end

    it 'raises an error, if an unknown field is given' do
      obj = DemoOptionals.new
      expect{obj.unknown_field = 'mwhoehaha'}.to raise_error(NoMethodError)
    end
  end

  context 'typed_input' do
    let(:obj) { build_object_for_known_fields }

    it 'can be initialized' do
      expect(obj).to be_kind_of(DemoTyped)
    end
    it 'raises a type error, when a required field is populated incorrectly' do
      expect{DemoTyped.new(required_1: 1.1, required_2: 'input')}.to raise_error(TypeError, 'required_1 has the wrong type; Fixnum was expected, but got Float')
    end
    it 'raises a type error, when an optional field is populated incorrectly' do
      expect{DemoTyped.new(required_1: 1, required_2: 'input', optional_1: 'incorrect')}.to raise_error(TypeError, 'optional_1 has the wrong type; Float was expected, but got String')
    end
    it 'can change the type of a field without type' do
      obj.optional_2 = 'String'
      obj.optional_2 = 1.1
      expect(obj.optional_2).to eq(1.1)
    end
    it 'raises a type error, when a required field is populated incorrectly' do
      expect{obj.required_1 = 'incorrect'}.to raise_error(TypeError, 'required_1 has the wrong type; Fixnum was expected, but got String')
    end
    it 'raises a type error, when an optional field is populated incorrectly' do
      expect{obj.optional_1 = 'incorrect'}.to raise_error(TypeError, 'optional_1 has the wrong type; Float was expected, but got String')
    end
    it 'raises nothing, when an optional field is nilled' do
      obj.optional_1 = nil
      expect(obj.optional_1).to be_nil
    end

    def build_object_for_known_fields
      DemoTyped.new(required_1: 1, required_2: 'input', optional_1: 1.1)
    end
  end

  context 'nested_input' do
    it 'initializes the object, when the optional structures is not used' do
      obj = DemoNestedBooking.new(booking_id: 1, booking_date: Date.today)
      expect(obj).to be_kind_of(DemoNestedBooking)
      expect(obj.booking_date).to eq(Date.today)
    end

    it 'converts the hash to the given object' do
      obj = DemoNestedBooking.new(booking_id: 1, booking_date: Date.today, car: {car_model: 'Opel'})
      expect(obj).to be_kind_of(DemoNestedBooking)
      expect(obj.booking_date).to eq(Date.today)
      expect(obj.car).to be_kind_of(DemoNestedCar)
      expect(obj.car.car_model).to eq('Opel')
    end
  end

  context 'initialize' do
    it 'can initialize a basic object' do
      obj = DemoBasic.new

      expect(obj).to be_kind_of(DemoBasic)
      expect(obj).to be_kind_of(Objection::Base)
    end

    it 'optional fields can be queried' do
      obj = DemoOptionals.new(optional_1: 'value_1', optional_2: 'value_2')
      expect(obj.optional_1).to eq('value_1')
      expect(obj.optional_2).to eq('value_2')
    end

    it 'required fields can be queried' do
      obj = DemoRequires.new(required_1: 'value_1', required_2: 'value_2')
      expect(obj.required_1).to eq('value_1')
      expect(obj.required_2).to eq('value_2')
    end

    it 'raises an error. when unknown fields are supplied' do
      expect{DemoOptionals.new(unknown_field: 'dummy')}.to raise_error(Objection::Base::UnknownFieldGiven, 'unknown_field')
    end

    it 'raises an error. when not all required fields are supplied' do
      expect{DemoRequires.new(required_2: 'dummy')}.to raise_error(Objection::Base::RequiredFieldMissing, 'required_1')
    end

    it 'raises an error, when a required field is blank' do
      expect{DemoRequires.new(required_1: 'value', required_2: '')}.to raise_error(Objection::Base::RequiredFieldEmpty, 'required_2')
    end

    it 'raises an error, when a required field is nil' do
      expect{DemoRequires.new(required_1: nil, required_2: 'value')}.to raise_error(Objection::Base::RequiredFieldEmpty, 'required_1')
    end
  end

  context 'normalize input' do
    let(:object) { Objection::Base.new }

    it 'returns an empty hash, when no arguments are given' do
      hash = object.send(:normalize_input)
      expect(hash).to eq({})
    end

    it 'returns a symbolized hash, when a symbolized hash is given' do
      input = {field_1: '1', field_2: '2'}
      hash = object.send(:normalize_input, input)
      expect(hash).to eq(input)
    end

    it 'returns a symbolized hash, when one symbolic is given' do
      expected = {field_1: '1'}
      hash = object.send(:normalize_input, field_1: '1')
      expect(hash).to eq(expected)
    end

    it 'returns a symbolized hash, when multiple symbolics are given' do
      expected = {field_1: '1', field_2: '2'}
      hash = object.send(:normalize_input, field_1: '1', field_2: '2')
      expect(hash).to eq(expected)
    end

    it 'returns a symbolized hash, when one string is given' do
      expected = {field_1: '1'}
      hash = object.send(:normalize_input, 'field_1' => '1')
      expect(hash).to eq(expected)
    end

    it 'returns a symbolized hash, when a stringified hash is given' do
      input = {'field_1' => '1', 'field_2' => '2'}
      expected = {field_1: '1', field_2: '2'}
      hash = object.send(:normalize_input, input)
      expect(hash).to eq(expected)
    end
  end

  context '(un)known fields' do
    let(:obj) { build_object_for_known_fields }

    it 'builds a list from the required and optional fields' do
      expect(obj.send(:known_fields)).to eq([:field_1, :field_2])
    end

    it 'builds a list of the unknown fields' do
      expect(obj).to receive(:present_fields).and_return([:field_1, :field_2, :fields_3])
      expect(obj.send(:unknown_fields)).to eq([:fields_3])
    end

    it 'return true, when unkown fields are present' do
      allow(obj).to receive(:unknown_fields).and_return([:field_1])
      expect(obj.send(:unknown_fields_present?)).to eq(true)
    end

    it 'return false, when unkown fields are absent' do
      allow(obj).to receive(:unknown_fields).and_return([])
      expect(obj.send(:unknown_fields_present?)).to eq(false)
    end

    def build_object_for_known_fields
      obj = Objection::Base.new
      obj.class.instance_variable_set('@required_fields', [:field_1])
      obj.class.instance_variable_set('@optional_fields', [:field_2])
      obj
    end
  end

  context 'define accessors' do
    let(:object) { build_object_for_accessors }

    before do
      object.send(:define_accessors)
    end

    it 'object responds to getter for required field' do
      expect(object.respond_to?(:required_1)).to eq(true)
    end
    it 'object responds to setter for required field' do
      expect(object.respond_to?(:required_1=)).to eq(true)
    end
    it 'object responds to getter for optional field' do
      expect(object.respond_to?(:optional_1)).to eq(true)
    end
    it 'object responds to setter for optional field' do
      expect(object.respond_to?(:optional_1=)).to eq(true)
    end

    def build_object_for_accessors
      obj = Objection::Base.new
      allow(obj).to receive(:required_fields).and_return([:required_1])
      allow(obj).to receive(:optional_fields).and_return([:optional_1])
      obj
    end
  end
end
