# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

namespace :data do
  task :mobile_assets do
    data_file = DataFile.new 'mobile_assets'

    data_file.data['mobile_assets'] ||= []

    data_file.data['mobile_assets'].each do |asset|
      puts "Updating from: #{asset['url']}"
      xml = Faraday.new.get(asset['url']).body

      next unless xml

      entry = Plist.parse_xml xml
      asset['asset_type'] = entry['AssetType']

    rescue StandardError
      puts 'Unable to parse element'
    end

    data_file.save
  end
end
