# 

require 'yaml'

FILE_NAME = ARGV[1]

dictionary = YAML.load_file FILE_NAME

dictionary.