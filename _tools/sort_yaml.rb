# 

require 'yaml'
require 'active_support/all'

FILE_NAME = ARGV[0]

items = YAML.load_file FILE_NAME

items.sort_by! { |item| item['name'] }

File.open(FILE_NAME, "w") { |file| file.write(items.to_yaml) }