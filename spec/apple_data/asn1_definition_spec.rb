# frozen_string_literal: true

require 'spec_helper'

describe AppleData::ASN1Definition do
  described_class.all.each do |file|
    it "parses the file #{file.path}" do
      expect(ASN1Parser::Parser.parse_file(file.path)).not_to be_nil
    end
  end
end
