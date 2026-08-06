# frozen_string_literal: true

AppleData::Schemas::FactoryDataRestore = AppleData::DataFile.define do
  self.default_filename = 'fdr'

  collection :fdr_modes do
    attribute :description, :string
  end

  collection :fdr_objects, AppleData::Models::IMG4::Object

  collection :fdr_properties, AppleData::Models::IMG4::Property
end
