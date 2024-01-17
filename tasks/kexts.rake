# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'
require_relative '../lib/kext'

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

  namespace :kexts do
    desc 'handle dumpstate'
    task :dumpstate do
      state = KextStatDumpState.new $stdin.read

      data_file = DataFile.new 'kext'
      kexts = data_file.collection :kexts
      state.entries.each do |entry|
        kext = kexts.ensure_key entry.id
        case entry
        when KextStatDumpState::KextBundle
          kext['path'] = entry.path
          kext['signer'] = entry.signer
          unless entry.uuid.blank?
            kext['uuids'] ||= []
            kext['uuids'] << entry.uuid unless kext['uuids'].include?(entry.uuid)
          end
          kext['type'] = entry.type
          kext['codeless'] = true if entry.codeless
        when KextStatDumpState::KextEntry
          kext['codeless'] if entry.codeless
          kext['signer'] = entry.signer if entry.signer
          unless entry.uuid.blank?
            kext['uuids'] ||= []
            kext['uuids'] << entry.uuid unless kext['uuids'].include?(entry.uuid)
          end
          kext['collections'] = []
          kext['collections'] << entry.collection unless kext['collections'].include?(entry.collection)
        end
      end
      kexts.sort

      data_file.save
    end
  end
end
