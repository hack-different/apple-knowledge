# frozen_string_literal: true

require_relative '../lib/common'

namespace :data do
  desc 'update firmwares from example manifests in tmp/build_manifests'
  task :firmware do
    data_file = DataFile.new 'firmware'

    firmware_types = data_file.collection :firmware_types

    Dir.glob(File.join(TMP_DIR, 'build_manifests', '*.plist')) do |file_path|
      puts "Reading build manifest file #{file_path}"
      build_manifest = Plist.parse_xml file_path

      build_manifest['BuildIdentities'].each do |identity|
        identity['Manifest'].each do |firmware_type, element|
          item = firmware_types.ensure_key firmware_type
          item['type'] ||= nil
          item['filenames'] ||= []
          if element['Info'] && element['Info']['Path']
            trimmed_path = element['Info']['Path'].split('/').last
            item['filenames'] |= [trimmed_path]
          end
        end
      end
    end

    data_file.save
  end
end
