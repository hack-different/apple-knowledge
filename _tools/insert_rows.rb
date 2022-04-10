# frozen_string_literal: true

# typed: ignore

require 'yaml'

DATA_FILE = ARGV[0]
ROW_ID_KEY = ARGV[1] || 'name'
KEYED_ON = ARGV[2]

data = YAML.load_file DATA_FILE

collection = KEYED_ON ? data[KEYED_ON] : data

$stdin.each_line do |line|
  line = line.strip
  next if collection.any? { |row| row[ROW_ID_KEY] == line }

  new_row = {}
  new_row[ROW_ID_KEY] = line
  collection << new_row
end

collection.each do |row|
  row['description'] ||= nil
end

collection.sort_by! { |row| row[ROW_ID_KEY].downcase }

File.write DATA_FILE, data.to_yaml
