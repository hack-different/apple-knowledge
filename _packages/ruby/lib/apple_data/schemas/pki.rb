# frozen_string_literal: true

AppleData::Schemas::PKI = AppleData::DataFile.define do
  self.default_filename = 'pki'

  collection :certificate_names do
    attribute :key, :string
    attribute :name, :string
    attribute :issuer, :string
  end

  collection :keys do
    attribute :title, :string
    attribute :certificates, :string, collection: true
  end

  collection :oids do
    attr_accessor :key

    attribute :name, :string
    attribute :title, :string
    attribute :type, :string
    attribute :description, :string
    attribute :apple_description, :string
    attribute :found_in, :string, collection: true
    attribute :issuers, :string, collection: true
    attribute :ous, :string, collection: true

    define_method :to_s do
      [name, title, description, key].reject(&:blank?).first
    end
  end
end
