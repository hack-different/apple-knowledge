#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'cfpropertylist'
require 'active_support/all'
require 'yaml'
require 'macho'

class IORegClass
end

IOREG_DATA_FILE = File.join(File.dirname(__FILE__), '../_data/ioreg.yaml')

result = YAML.load_file IOREG_DATA_FILE

result ||= {}
result['classes'] ||= []

unique_classes = result['classes'].select { |entry| entry['name'] }

CLASS_NAME_REGEX = /([A-Za-z0-9]+)\s+<class ([a-zA-Z0-9:]+),/

INPUT_DIRECTORY = ARGV[0]

Dir.glob(File.join(INPUT_DIRECTORY, '*.txt')).each do |file|
  puts "Scanning File: #{file}"
  content = File.readlines(file).each do |line|
    match = line.match CLASS_NAME_REGEX

    next unless match

    tree = match[2].split(/:/).reverse

    puts "#{match[1]}: #{tree.inspect}"

    unique_classes << tree.first
  rescue StandardError => e
    puts "Error Line: #{line}"
  end
end

unique_classes.uniq!

result['classes'] = unique_classes.map { |c| { 'name' => c, 'description' => nil } }

File.write(IOREG_DATA_FILE, result.to_yaml)
