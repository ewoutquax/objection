require_relative '../spec_helper'
require_relative '../support/demo_basic'
require_relative '../support/demo_requires'

describe Objection do
  context 'base' do
    it 'can instantiate the class' do
      expect(Objection::Base.new).to be_kind_of(Objection::Base)
    end
    it 'can find the requires-function' do
      expect(Objection::Base.new.respond_to?(:requires)).to eq(true)
    end
    it 'can find the optionals-function' do
      expect(Objection::Base.new.respond_to?(:optionals)).to eq(true)
    end
  end

  context 'initialize' do
    it 'can initialize a basic object' do
      obj = DemoBasic.new

      expect(obj).to be_kind_of(DemoBasic)
      expect(obj).to be_kind_of(Objection::Base)
    end
  end

  context 'requires' do
    it 'can define required fields' do
      obj = DemoRequires.new

      expect(obj).to be_kind_of(DemoRequires)
      expect(obj).to be_kind_of(Objection::Base)
      expect(obj.required_fields).to eq([:required_1, :required_2])
    end
  end
end
