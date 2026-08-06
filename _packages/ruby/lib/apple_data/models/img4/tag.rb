# frozen_string_literal: true

module AppleData
  module Models
    module IMG4
      # Generic IMG4 DER "tag"
      class Tag < Shale::Mapper
        attr_accessor :key

        attribute :name, :string
        attribute :description, :string
        attribute :title, :string
        attribute :alias, :string, collection: true
        attribute :example, :string
        attribute :type, :string

        def to_s
          name || title || description || key
        end

        def to_sym
          to_s.to_sym
        end
      end
    end
  end
end
