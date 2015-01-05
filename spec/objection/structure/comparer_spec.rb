require_relative '../../spec_helper'

describe Objection::Structure::Comparer do
  context 'detect missing fields' do
    let(:comparer) { Objection::Structure::Comparer.new(@structure_in) }

    it 'from 1 level structures' do
      @structure_in = [:field_1, :field_2]
      expect(comparer.missing_fields([:field_1, :field_2])).to eq([])
      expect(comparer.missing_fields([:field_1])).to eq([:field_2])
    end
    it 'from 2 level structures' do
      @structure_in = [:field_1, field_2: [:field_2_1]]
      expect(comparer.missing_fields([:field_1])).to eq([field_2: [:field_2_1]])
      expect(comparer.missing_fields([:field_1, :field_2])).to eq([field_2: [:field_2_1]])
      expect(comparer.missing_fields([:field_1, field_2: [:field_2_1]])).to eq([])
    end
    it 'from 3 level structures' do
      @structure_in = [:field_1, field_2: [:field_2_1, field_2_2: [:field_2_2_1]]]
      expect(comparer.missing_fields([:field_1, field_2: [:field_2_1, field_2_2: [:field_2_2_1]]])).to eq([])
      expect(comparer.missing_fields([:field_1])).to eq([field_2: [:field_2_1, field_2_2: [:field_2_2_1]]])
    end
  end

  context 'detect unknown fields' do
    let(:comparer) { Objection::Structure::Comparer.new(@structure_in) }

    it 'from 1 level structures' do
      @structure_in = [:field_1, :field_2]
      expect(comparer.unknown_fields([:field_1, :field_2])).to eq([])
      expect(comparer.unknown_fields([:field_1])).to eq([])
      expect(comparer.unknown_fields([:field_1, field_2: [:field_2_1]])).to eq([{field_2: [:field_2_1]}])
      expect(comparer.unknown_fields([:field_3])).to eq([:field_3])
    end
    it 'from 2 level structures' do
      @structure_in = [:field_1, field_2: [:field_2_1]]
      expect(comparer.unknown_fields([:field_1, field_2: [:field_2_1]])).to eq([])
      expect(comparer.unknown_fields([field_2: [:field_2_1]])).to eq([])
    end
    it 'from 3 level structures' do
      @structure_in = [:field_1, field_2: [:field_2_1, field_2_2: [:field_2_2_1]]]
      expect(comparer.unknown_fields([:field_1, field_2: [:field_2_1, field_2_2: [:field_2_2_1]]])).to eq([])
      expect(comparer.unknown_fields([])).to eq([])
    end
  end
end
