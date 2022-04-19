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
    task :missing_hashes do
      data_file = DataFile.new 'ipsw'
      collection = data_file.collection :ipsw_files

      collection.each do |_filename, entry|
        next unless entry['urls']&.any?
        next if entry['hashes']&.any?

        puts entry['urls'].first
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
