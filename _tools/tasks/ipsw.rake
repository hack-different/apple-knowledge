# frozen_string_literal: true

require_relative '../lib/shasum'
require_relative '../lib/merkle'

namespace :data do
  namespace :ipsw do
    desc 'update hashes for IPSW from shasum file'
    task :hashes, [:shasums] do |_task, args|
      filename = args[:shasums]
      raise("File #{filename} does not exist") unless File.exist?(filename)

      data_file = DataFile.new 'ipsw'

      sum = SHASum.from_file filename
      sum.update_collection(data_file.collection(:ipsw_files))
      data_file.save
    end

    desc 'missing IPSWs that have URLs but no hashes'
    task :missing_hashes, [:batch_size] do |_task, args|
      data_file = DataFile.new 'ipsw'
      collection = data_file.collection :ipsw_files

      urls = collection.map do |_filename, entry|
        next unless entry['urls']&.any?
        next if entry['hashes']&.any?

        url = entry['urls'].first
        url && !url.blank? ? url : nil
      end

      if args[:batch_size]
        FileUtils.mkdir_p File.join(TMP_DIR, 'ipsw', 'urls')
        batch_size = args[:batch_size].to_i
        puts "Writing to download files with batch size of #{batch_size}"
        urls.compact.each_slice(batch_size).each_with_index do |url_list, index|
          file_path = File.join(TMP_DIR, 'ipsw', 'urls', "batch_#{index}.txt")
          puts "Writing group #{index} to #{File.realpath(file_path)}"
          File.open(file_path, 'w') do |file|
            url_list.each do |url|
              file.write url
            end
          end
        end
      else
        urls.compact.each { |url| puts url }
      end
    end

    desc 'create merkle tree from zip'
    task :merkle, [:file] do |_task, args|
      tree = MerkleTree.new File.open(args[:file])
      tree.scan

      ap tree.to_h
    end
  end
end
