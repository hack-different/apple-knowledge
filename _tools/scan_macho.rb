#!/usr/bin/env ruby
# frozen_string_literal: true

# typed: ignore

require_relative 'lib/common'

MACHO_FILE = File.join(File.dirname(__FILE__), '../_data/mach_o.yaml')
FILESET_REGION = /__REGION\d+/

result = YAML.load_file MACHO_FILE

if ARGV.length != 1
  puts 'Usage: scan_macho.rb <EXAMPLE_FILE>'
  exit(-1)
end

file = MachO.open ARGV[0]

binary = file.is_a?(MachO::FatFile) ? file.machos[0] : file

result ||= {}

result['segments'] ||= {}
result['commands'] ||= {}

binary.segments.each do |segment|
  next if (binary.filetype == :fileset) && FILESET_REGION.match?(segment.segname)

  seg = result['segments'][segment.segname] ||= { 'description' => nil }

  segment.sections.each do |section|
    seg[section.sectname] ||= { 'description' => nil }
  end
end

MachO::LoadCommands::LOAD_COMMANDS.each do |key, value|
  result['commands'][value.to_s] = { 'description' => nil, 'value' => key }
end

File.write(MACHO_FILE, result.to_yaml)
