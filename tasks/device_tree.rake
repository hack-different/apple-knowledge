# frozen_string_literal: true

require 'mootool'

namespace :data do
  desc 'update device files from device trees'
  task :device_tree do
    device_dir = File.join(DATA_DIR, 'devices')

    FileUtils.mkdir_p(device_dir)
    Dir.glob(File.join(TMP_DIR, 'ipsw', '**', 'DeviceTree.*.im4p')).each do |file|
      puts "Processing #{file}"
      img = MooTool::Img4::File.new file
      next unless img.payload?

      dt = MooTool::DeviceTree.new(img.payload)
      tree_hash = dt.root.to_h

      identity = tree_hash['model']

      output_path = File.join(device_dir, "#{identity}.yaml")
      File.write(output_path, { 'model' => identity, 'device_tree' => tree_hash }.to_yaml)
    rescue StandardError => e
      puts "Error processing #{file}: #{e}"
      next
    end
  end
end
