# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleData::Schemas::IMG4 do
  let(:instance) { described_class.new }

  it 'has unmapped' do
    aggregate_failures do
      expect(instance.unmapped).to be_a(Array)
      expect(instance.unmapped).not_to be_empty
      expect(instance.unmapped).to all(be_a(String))
    end
  end

  it 'has core' do
    aggregate_failures do
      expect(instance.core).to be_a(Hash)
      expect(instance.core).not_to be_empty
      expect(instance.core.values.compact).to all(be_a(AppleData::Models::IMG4::Tag))
    end
  end

  it 'has objects' do
    aggregate_failures do
      expect(instance.objects).to be_a(Hash)
      expect(instance.objects).not_to be_empty
      expect(instance.objects.values.compact).to all(be_a(AppleData::Models::IMG4::Object))
    end
  end

  it 'has cryptex_objects' do
    aggregate_failures do
      expect(instance.cryptex_objects).to be_a(Hash)
      expect(instance.cryptex_objects).not_to be_empty
      expect(instance.cryptex_objects.values.compact).to all(be_a(AppleData::Models::IMG4::Object))
    end
  end

  it 'has lpol_properties' do
    aggregate_failures do
      expect(instance.lpol_properties).to be_a(Hash)
      expect(instance.lpol_properties).not_to be_empty
      expect(instance.lpol_properties.values.compact).to all(be_a(AppleData::Models::IMG4::Property))
    end
  end

  it 'has #all' do
    aggregate_failures do
      expect(instance.all).to be_a(Hash)
      expect(instance.all).not_to be_empty
    end
  end
end
