# frozen_string_literal: true

RSpec.describe AppleData::Schemas::PKI do
  let(:instance) { described_class.new }

  it 'has entries' do
    aggregate_failures do
      expect(instance.oids).to be_a(Hash)
      expect(instance.oids).not_to be_empty
    end
  end

  it 'has entries that respond to #to_s' do
    aggregate_failures do
      expect(instance.oids[:'1.2.840.113635.100.6.1.15'].to_s).to be_a(String)
      expect(instance.oids[:'1.2.840.113635.100.6.1.15'].to_s).to eq 'appleImg4ManifestSpecification'
    end
  end
end
