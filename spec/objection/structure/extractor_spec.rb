require_relative '../../spec_helper'

describe Objection::Structure::Extractor do
  context 'build structure' do
    let(:extraction) { Objection::Structure::Extractor.extract(@input) }

    it 'from 1 layered input' do
      @input = {field_1: 'value_1', field_2: 'value_2'}
      expect(extraction).to eq([:field_1, :field_2])
    end

    it 'from 2 layered input' do
      @input = {field_1: 'value_1', 'field_2' => {field_2_1: 'value_2_1'}}
      expect(extraction).to eq([:field_1, field_2: [:field_2_1]])
    end

    it 'from 3 layered input' do
      @input = {field_1: 'value_1', field_2: {field_2_1: 'value_2_1', field_2_2: {field_2_2_1: 'value_2_2_1'}}}
      expect(extraction).to eq([:field_1, field_2: [:field_2_1, field_2_2: [:field_2_2_1]]])
    end
  end
end
