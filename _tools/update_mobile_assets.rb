#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '_common'

MOBILE_ASSETS_PATH = File.join(File.dirname(__FILE__), '../_data/mobile_assets.yaml')

result = YAML.load_file MOBILE_ASSETS_PATH

result.each do |asset|
  puts "Updating from: #{asset['url']}"
  xml = Faraday.new.get(asset['url']).body

  next unless xml

  entry = Plist.parse_xml xml
  asset['asset_type'] = entry['AssetType']
rescue StandardError
  puts 'Unable to parse element'
end

File.write(MOBILE_ASSETS_PATH, result.to_yaml)
