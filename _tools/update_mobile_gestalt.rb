#!/usr/bin/env ruby
# frozen_string_literal: true

# typed: ignore

require_relative 'lib/common'

GESTALT_DATA_FILE = File.join(File.dirname(__FILE__), '../_data/mobile_gestalt.yaml')

def obfuscate(input_key)
  hashed = Digest::MD5.digest "MGCopyAnswer#{input_key}"

  Base64.encode64(hashed).delete('=').squish
end

data = YAML.load_file GESTALT_DATA_FILE

data['known_keys'].each do |key|
  key['obfuscated'] = obfuscate(key['question'])
  key['type'] = nil
end

data['known_keys'].sort_by! { |q| q['question'].downcase }

File.write GESTALT_DATA_FILE, data.to_yaml
