# 

require 'yaml'
require 'active_support/all'

FILE_NAME = ARGV[0]

dictionary = YAML.load_file FILE_NAME

result = dictionary.sort_by { |item| item[:name] }

File.open(FILE_NAME, "w") { |file| file.write(result.to_yaml) }