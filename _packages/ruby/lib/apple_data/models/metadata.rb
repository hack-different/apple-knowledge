# frozen_string_literal: true

module AppleData
  module Models
    class Metadata < AppleData::SchemaBase
      attribute :credits, :string, collection: true
      attribute :description, :string
      attribute :auto_sort, :boolean
    end
  end
end
