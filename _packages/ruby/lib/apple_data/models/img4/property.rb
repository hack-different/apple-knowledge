# frozen_string_literal: true

module AppleData
  module Models
    module IMG4
      # An IMG4 property is a name and a value
      class Property < AppleData::Models::IMG4::Tag
        attribute :roots, :string, collection: true
        attribute :example, :string
      end
    end
  end
end
