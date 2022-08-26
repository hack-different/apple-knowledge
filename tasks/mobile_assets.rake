# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'
require 'hashie'

namespace :data do
  desc 'Update files from MESU'
  task :mobile_assets do
    data_file = DataFile.new 'mobile_assets'
    ipsw_data_file = DataFile.new 'ipsw'

    data_file.data['mobile_assets'] ||= []
    new_entries = []

    ipsw_collection = ipsw_data_file.collection :ipsw_files

    data_file.data['mobile_assets'].each do |asset|
      puts "Updating from: #{asset['url']}"
      xml = Faraday.new.get(asset['url']).body

      next unless xml

      entry = Plist.parse_xml xml
      entry.extend(Hashie::Extensions::DeepLocate)
      asset['asset_type'] = entry['AssetType'] if entry.key? 'AssetType'

      locator = lambda do |_key, value, _object|
        value.is_a?(String) && value.end_with?('.ipsw')
      end

      ipsws = entry.deep_locate(locator).to_a

      ipsws.each do |ipsw|
        next unless ipsw.key? 'FirmwareURL'

        url = URI.parse(ipsw['FirmwareURL'].strip)
        filename = File.basename(url.path).strip

        ipsw_entry = ipsw_collection.ensure_key(filename, description: false)
        new_entries << ipsw_entry
        ipsw_entry['metadata'] ||= {}
        ipsw_entry['hashes'] ||= {}
        ipsw_entry['urls'] ||= []
        ipsw_entry['hashes']['sha1'] = ipsw['FirmwareSHA1'] if ipsw.key? 'FirmwareSHA1'
        ipsw_entry['metadata']['build_number'] = ipsw['BuildVersion'] if ipsw.key? 'BuildVersion'
        ipsw_entry['metadata']['version'] = ipsw['ProductVersion'] if ipsw.key? 'ProductVersion'

        unless ipsw_entry['urls'].any? { |u| u['url'] == ipsw['FirmwareURL'] }
          ipsw_entry['urls'] << { 'url' => ipsw['FirmwareURL'] }
        end
      end

    rescue StandardError
      puts 'Unable to parse element'
    end

    data_file.save
    ipsw_data_file.save
  end
end
