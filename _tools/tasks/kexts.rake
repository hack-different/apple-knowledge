# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

KERNEL_COLLECTION_DIR = '/System/Library/KernelCollections'

namespace :data do
  task :kexts do
    data_file = DataFile.new 'kext'
    data_file.data['kexts'] ||= []

    result.each { |entry| entries[entry['id']] = entry }

    Dir.glob(File.join(KERNEL_COLLECTION_DIR, '*.kc')).each do |collection|
      collection_file = File.basename collection
      file = MachO.open collection

      binary = file.is_a?(MachO::FatFile) ? file.fat_archs[0] : file

      binary.command(:LC_FILESET_ENTRY).each do |command|
        bundle_id = command.entry_id.to_s
        entries[bundle_id] ||= { 'id' => bundle_id, 'description' => nil }
        collection = entries[bundle_id]['collections'] ||= []
        collection << collection_file unless collection.include? collection_file
      end
    end

    Dir.glob(File.join(KERNEL_COLLECTION_DIR, '*.kc.elides')).each do |collection|
      data = File.read(collection).split
      data.each do |kext|
        entries[kext] ||= { 'id' => kext, 'description' => nil }
      end
    end

    result = entries.values

    result.sort_by! { |entry| entry['id'] }

    File.write(KEXT_DATA_FILE, result.to_yaml)
  end
end
