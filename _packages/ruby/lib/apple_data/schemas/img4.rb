# frozen_string_literal: true

AppleData::Schemas::IMG4 = AppleData::DataFile.define do
  self.default_filename = 'img4'

  collection :unmapped

  collection :core, AppleData::Models::IMG4::Tag
  collection :lpol_properties, AppleData::Models::IMG4::Property
  collection :cryptex_properties, AppleData::Models::IMG4::Property
  collection :cryptex_objects, AppleData::Models::IMG4::Object
  collection :manifest_properties, AppleData::Models::IMG4::Property
  collection :objects, AppleData::Models::IMG4::Object
  collection :img4_tags, AppleData::Models::IMG4::Tag

  collection :types do
    attribute :description, :string
  end
end
