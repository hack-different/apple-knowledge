# frozen_string_literal: true

module AppleData
  # An ASN1 definition
  class ASN1Definition
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def self.all
      Dir[AppleData.get_path('asn1', '**', '*.asn')].map { |file| File.expand_path(file) }.map { |file| new(file) }
    end
  end
end
