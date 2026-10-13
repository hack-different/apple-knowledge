# frozen_string_literal: true

RSpec.describe AppleData::Schemas::PKI do
  let(:instance) { described_class.new }

  it 'has entries' do
    aggregate_failures do
      expect(instance.oids).to be_a(Hash)
      expect(instance.oids).not_to be_empty
    end
  end

  it 'preserves the IMG4 manifest display name' do
    expect(instance.oids[:'1.2.840.113635.100.6.1.15'].to_s).to eq 'appleImg4ManifestSpecification'
  end

  it 'loads OID symbols from YAML' do
    expect(instance.oids['1.2.840.113635.100.4.1'].symbol).to eq 'oidAppleExtendedKeyUsageCodeSigning'
  end

  it 'retains collection identifiers', :aggregate_failures do
    expect(instance.certificate_names[:ucrt].key).to eq 'ucrt'
    expect(instance.keys[:uik].key).to eq 'uik'
    expect(instance.oids['1.2.840.113635.100.10.1'].key).to eq '1.2.840.113635.100.10.1'
  end

  it 'loads certificate references', :aggregate_failures do
    expect(instance.keys[:uik].certificates).to eq ['ucrt']
    expect(instance.certificate_names[:ucrt].issuer).to eq 'Basic Attestation User Root CA'
  end

  it 'loads OID array attributes', :aggregate_failures do
    oid = instance.oids['1.2.840.113635.100.10.1']

    expect(oid.found_in).to eq ['ucrt']
    expect(oid.issuers).to eq ['FDRDC-UCRT-SUBCA']
    expect(oid.ous).to eq ['ucrt Leaf Certificate']
  end

  describe 'OID display fallback' do
    let(:oid_class) { described_class.const_get(:COLLECTIONS).fetch(:oids).mapper }

    [nil, '', " \t\n"].each do |blank|
      context "with #{blank.inspect} fields" do
        let(:oid) do
          oid_class.new(name: blank, title: blank, description: blank,
                        symbol: 'oidSymbol', apple_description: 'Apple description')
        end

        it 'prefers the name' do
          oid.name = 'Name'
          oid.title = 'Title'
          oid.description = 'Description'
          oid.key = '1.2.3'

          expect(oid.to_s).to eq 'Name'
        end

        it 'falls back to the title' do
          oid.title = 'Title'
          oid.description = 'Description'
          oid.key = '1.2.3'

          expect(oid.to_s).to eq 'Title'
        end

        it 'falls back to the description' do
          oid.description = 'Description'
          oid.key = '1.2.3'

          expect(oid.to_s).to eq 'Description'
        end

        it 'falls back to the identifier without using symbol or Apple description' do
          oid.key = '1.2.3'

          expect(oid.to_s).to eq '1.2.3'
        end

        it 'returns an empty string when all display candidates are blank' do
          oid.key = blank

          expect(oid.to_s).to eq ''
        end
      end
    end
  end
end
