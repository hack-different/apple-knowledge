# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'

RSpec.describe AppleData::DataFile do
  it 'has data files' do
    expect(described_class.all).not_to be_empty
  end

  describe 'file loading and persistence' do
    after do
      FileUtils.remove_entry(directory)
    end

    let(:directory) { Dir.mktmpdir('apple-data-spec') }
    let(:path) { File.join(directory, 'pki.yaml') }
    let(:schema) { AppleData::Schemas::PKI }
    let(:document) do
      { 'metadata' => { 'collections' => ['oids'] },
        'oids' => { '1.2.3' => { 'name' => 'Original' } } }
    end

    before do
      File.write(path, document.to_yaml)
    end

    it 'preserves the schema when loading an explicit path', :aggregate_failures do
      instance = schema.from_path(path)

      expect(instance).to be_a(schema)
      expect(instance.oids['1.2.3'].to_s).to eq 'Original'
      expect(instance.data[:oids][:'1.2.3'][:name]).to eq 'Original'
    end

    it 'initializes metadata for a missing file', :aggregate_failures do
      instance = described_class.from_path(File.join(directory, 'missing.yaml'))

      expect(instance.metadata).to include('collections' => [], 'credits' => [], 'description' => nil)
      expect(instance.collections).to be_empty
    end

    it 'initializes metadata for an empty YAML document' do
      File.write(path, '')

      expect(described_class.from_path(path).collections).to be_empty
    end

    it 'rejects a document that is not a mapping' do
      File.write(path, %w[unexpected array].to_yaml)

      expect { described_class.from_path(path) }.to raise_error(ArgumentError, "Expected a YAML mapping in #{path}")
    end

    it 'replaces cached raw and mapped collections on reload', :aggregate_failures do
      allow(AppleData).to receive(:data_location).and_return(directory)
      instance = schema.new
      instance.oids
      instance.collection(:oids)
      document['oids']['1.2.3']['name'] = 'Reloaded'
      File.write(path, document.to_yaml)

      instance.load_file('pki')

      expect(instance.oids['1.2.3'].to_s).to eq 'Reloaded'
      expect(instance.collection(:oids).data['1.2.3']['name']).to eq 'Reloaded'
    end

    it 'writes ordinary YAML that can be loaded again' do
      allow(AppleData).to receive(:data_location).and_return(directory)
      instance = schema.new
      instance.save!

      expect(YAML.load_file(path)).to eq document.merge(
        'metadata' => document['metadata'].merge('description' => nil, 'credits' => [])
      )
    end

    it 'normalizes hashes nested inside arrays when saving' do
      document['examples'] = [{ 'name' => 'Example' }]
      File.write(path, document.to_yaml)
      instance = described_class.from_path(path)

      instance.save!

      expect(YAML.load_file(path)['examples']).to eq document['examples']
    end

    it 'retains the loaded document when a reload fails', :aggregate_failures do
      allow(AppleData).to receive(:data_location).and_return(directory)
      instance = schema.new
      original = instance.oids
      File.write(path, 'false')

      expect { instance.load_file('pki') }.to raise_error(ArgumentError)
      expect(instance.oids).to equal(original)
      expect(instance.data['oids']).to eq document['oids']
    end

    it 'persists array collection sorting', :aggregate_failures do
      File.write(path, { 'metadata' => { 'collections' => ['items'] }, 'items' => %w[z a m] }.to_yaml)
      instance = described_class.from_path(path)

      instance.sort!
      instance.save!

      expect(instance.collection(:items).data).to eq %w[a m z]
      expect(YAML.load_file(path)['items']).to eq %w[a m z]
    end
  end

  described_class.all.each do |klass|
    context klass.name do
      let(:instance) { klass.new }

      klass.const_get(:COLLECTIONS).each do |name, collection|
        context collection.name do
          it 'is consistent' do
            expect(instance.send(name)).not_to be_nil
          end
        end
      end
    end
  end
end
