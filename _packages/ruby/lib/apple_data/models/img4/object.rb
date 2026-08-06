# frozen_string_literal: true

module AppleData
  module Models
    module IMG4
      class Object < AppleData::Models::IMG4::Tag
        attribute :encoding, :string
        attribute :firmware_name, :string
        attribute :recovery, :boolean
        attribute :restore, :boolean
        attribute :firmware, :boolean
        attribute :subtype, :string
        attribute :manifest, :boolean
        attribute :nullable, :boolean
        attribute :roots, :string, collection: true
        attribute :metadata, :string, collection: true
        attribute :values, :string, collection: true
        attribute :width, :integer
      end
    end
  end
end
