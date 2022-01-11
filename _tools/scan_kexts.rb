#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'cfpropertylist'
require 'active_support/all'
require 'yaml'
require 'macho'

KEXT_DATA_FILE = File.join(File.dirname(__FILE__), '../_data/kext.yaml')

result = YAML.load_file KEXT_DATA_FILE

result ||= {}

puts 'Usage: scan_kexts.rb <KEXT_COLLECTION>'

file = MachO.open ARGV[0]

binary = file.is_a?(MachO::FatFile) ? file.fat_archs[0] : file

binary.command(:LC_FILESET_ENTRY).each do |command|
  result[command.entry_id.to_s] ||= { 'description' => nil }
end

File.write(KEXT_DATA_FILE, result.to_yaml)
