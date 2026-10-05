# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleData::Schemas::FactoryDataRestore do
  let(:instance) { described_class.new }

  it 'has fdr_modes' do
    aggregate_failures do
      expect(instance.fdr_modes).to be_a(Hash)
      expect(instance.fdr_modes).not_to be_empty
      expect(instance.fdr_modes.keys).to match_array(%w[base mandev mansta])
      expect(instance.fdr_modes.values).to all(be_a(Shale::Mapper))
    end
  end

  it 'has fdr_objects' do
    aggregate_failures do
      expect(instance.fdr_objects).to be_a(Hash)
      expect(instance.fdr_objects).not_to be_empty
      expect(instance.fdr_objects.values.compact).to all(be_a(AppleData::Models::IMG4::Object))
    end
  end

  it 'has fdr_properties' do
    aggregate_failures do
      expect(instance.fdr_properties).to be_a(Hash)
      expect(instance.fdr_properties).not_to be_empty
      expect(instance.fdr_properties.values.compact).to all(be_a(AppleData::Models::IMG4::Property))
    end
  end
end
