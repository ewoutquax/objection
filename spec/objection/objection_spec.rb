require_relative '../spec_helper'
require_relative '../support/demo_basic'
require_relative '../support/demo_requires'
require_relative '../support/demo_optionals'

describe Objection do
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

  context 'requires' do
    it 'can define required fields' do
      obj = DemoRequires.new(:required_1, :required_2)
      obj_more = DemoRequiresMore.new(:required_3, :required_4)

      expect(obj).to be_kind_of(DemoRequires)
      expect(obj).to be_kind_of(Objection::Base)
      expect(obj.required_fields).to eq([:required_1, :required_2])
      expect(obj_more.required_fields).to eq([:required_3, :required_4])
    end
  end

  context 'optionals' do
    it 'can define optionals fields' do
      obj = DemoOptionals.new
      obj_more = DemoOptionalsMore.new

      expect(obj).to be_kind_of(DemoOptionals)
      expect(obj).to be_kind_of(Objection::Base)
      expect(obj.optional_fields).to eq([:optional_1, :optional_2])
      expect(obj_more.optional_fields).to eq([:optional_3, :optional_4])
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
end
