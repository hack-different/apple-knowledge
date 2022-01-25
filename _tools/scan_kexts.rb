#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'cfpropertylist'
require 'active_support/all'
require 'yaml'
require 'macho'

KERNEL_COLLECTION_DIR = '/System/Library/KernelCollections'

KEXT_DATA_FILE = File.join(File.dirname(__FILE__), '../_data/kext.yaml')

result = YAML.load_file KEXT_DATA_FILE

result ||= []

entries = {}

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
