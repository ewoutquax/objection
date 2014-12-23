require_relative '../spec_helper'
require_relative '../support/demo_basic'
require_relative '../support/demo_requires'
require_relative '../support/demo_optionals'

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
      obj = DemoRequires.new(:required_1, :required_2)
      obj_more = DemoRequiresMore.new(:required_3, :required_4)

      expect(obj).to be_kind_of(DemoRequires)
      expect(obj).to be_kind_of(Objection::Base)
      expect(obj.send(:required_fields)).to eq([:required_1, :required_2])
      expect(obj_more.send(:required_fields)).to eq([:required_3, :required_4])
    end

    it 'builds a list of missing required fields' do
      result = object.send(:missing_required_fields, [:field_1])
      expect(result).to eq([:field_2])
    end

    def build_object_for_required_fields
      obj = Objection::Base.new
      obj.class.instance_variable_set('@required_fields', [:field_1, :field_2])
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
  end

  context 'initialize' do
    it 'can initialize a basic object' do
      obj = DemoBasic.new

      expect(obj).to be_kind_of(DemoBasic)
      expect(obj).to be_kind_of(Objection::Base)
    end

    it 'raises an error. when not all expected fields are supplied' do
      expect{DemoRequires.new}.to raise_error(Objection::Base::RequiredFieldsMissing, ':required_1, :required_2')
    end
  end

  context '(un)known fields' do
    let(:obj) { build_object_for_known_fields }

    it 'builds a list from the required and optional fields' do
      expect(obj.send(:known_fields)).to eq([:field_1, :field_2])
    end

    it 'builds a list of the unknown fields' do
      expect(obj.send(:unknown_fields, [:field_1, :field_2, :fields_3])).to eq([:fields_3])
    end

    it 'return true, when unkown fields are present' do
      allow(obj).to receive(:unknown_fields).and_return([:field_1])
      expect(obj.send(:unknown_fields_present?, nil)).to eq(true)
    end

    it 'return false, when unkown fields are absent' do
      allow(obj).to receive(:unknown_fields).and_return([])
      expect(obj.send(:unknown_fields_present?, nil)).to eq(false)
    end

    def build_object_for_known_fields
      obj = Objection::Base.new
      obj.class.instance_variable_set('@required_fields', [:field_1])
      obj.class.instance_variable_set('@optional_fields', [:field_2])
      obj
    end
  end
end
