# frozen_string_literal: true

require_relative '../lib/shasum'

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
  end
end
