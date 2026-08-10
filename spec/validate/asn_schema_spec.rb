# frozen_string_literal: true

require 'spec_helper'

describe 'ASN schema validation' do
  Dir[File.join(File.dirname(__FILE__), '..', '..', '_data', 'asn1', '*.asn')].each do |file|
    resolved_path = File.expand_path(file)

    it "parses the file #{resolved_path}" do
      expect(ASN1Parser::Parser.parse_file(resolved_path)).not_to be_nil
    end
  end
end
