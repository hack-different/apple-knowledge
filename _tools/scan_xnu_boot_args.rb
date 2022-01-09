#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'set'
require 'active_support/all'

if ARGV.length != 1
  puts 'Usage: scan_xnu_boot_args <XNU_SOURCE_PATH>'
  exit(-1)
end

OUTPUT_FILE = File.join(File.dirname(__FILE__), '..', '_data', 'boot-args.yaml')

REQUIRED_KEYS = %w[description].freeze

XNU_SOURCE_ROOT = ARGV[0]

SUPPORTED_FILE_EXTENSIONS = %w[c h m mm cpp hpp hxx cxx].freeze

unless File.directory? XNU_SOURCE_ROOT
  puts "Path #{XNU_SOURCE_ROOT} is not a directory"
  exit(-1)
end

PARSE_ARGN = /PE_parse_boot_argn\(\s*"([^"]+)"/m
TUNABLE = /TUNABLE\(\w+,\s*\w+,\s*"([^"]+)",\s*\w+\)/m

result = YAML.load_file(OUTPUT_FILE).map(&:stringify_keys)

discovered_args = Set[]

Dir.glob(File.join(XNU_SOURCE_ROOT, '**', '*')).each do |entry|
  next if File.directory? entry
  next unless SUPPORTED_FILE_EXTENSIONS.include? File.extname(entry).delete_prefix('.')

  content = File.read entry

  discovered_args.merge content.scan(TUNABLE).flatten
  discovered_args.merge content.scan(PARSE_ARGN).flatten

rescue StandardError => e
  puts "Error in processing file #{entry}.  Inner error:\n\n#{e}"
end

discovered_args.each do |arg|
  next if result.any? { |item| item['name'] == arg }

  result << { name: arg }
end

result.each do |entry|
  REQUIRED_KEYS.each do |key|
    entry[key] = nil unless entry.key? key
  end
end

result.sort_by! { |entry| entry['name'] }

File.write(OUTPUT_FILE, result.to_yaml)
