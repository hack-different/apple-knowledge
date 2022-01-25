#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'cfpropertylist'
require 'active_support/all'
require 'yaml'
require 'macho'

# A single IOKit class
class IORegClass
  attr_accessor :description, :name, :parents, :known_names

  def initialize(klass_name)
    @name = klass_name
    @parents = []
  end

  def self.for_name(name)
    @instances ||= {}

    @instances[name] = IORegClass.new name unless @instances.key? name

    @instances[name]
  end

  def self.values
    @instances.values.sort_by(&:name)
  end

  def self.load_one(hash)
    instance = for_name hash['name']
    instance.description = hash['description']
    instance.parents = hash['parents']
    instance.known_names = (hash['known_names'] || []).sort
  end

  def to_h
    { 'name' => @name, 'description' => @description, 'parents' => @parents, 'known_names' => @known_names }
  end

  def user_client?
    @parents.include? 'IOUserClient'
  end
end

IOREG_DATA_FILE = File.join(File.dirname(__FILE__), '../_data/ioreg.yaml')

result = YAML.load_file IOREG_DATA_FILE

result ||= {}
result['classes'] ||= []

unique_classes = result['classes'].select { |entry| IORegClass.load_one(entry) }

CLASS_NAME_REGEX = /o\s([A-Za-z0-9\s,\-_]+)(@[a-fA-F0-9]+)?\s+<class ([a-zA-Z0-9:]+),/
BEGIN_PROPERTIES_REGEX = /\{$/
PROPERTY_LINE_REGEX = /"([A-Za-z0-9 ]+)" = ([^\n]+)$/
END_PROPERTIES_REGEX = /\}$/

INPUT_DIRECTORY = ARGV[0]

Dir.glob(File.join(INPUT_DIRECTORY, '*.txt')).each do |file|
  puts "Scanning File: #{file}"
  instance = nil
  File.readlines(file).each do |line|
    match = line.match CLASS_NAME_REGEX

    next unless match

    tree = match[3].split(/:/).reverse

    puts "#{match[1]}: #{tree.inspect}"

    name = match[1].strip

    instance = IORegClass.for_name(tree.first)
    instance.parents = tree[1..]
    instance.known_names ||= []
    instance.known_names << name unless instance.known_names.include? name
  rescue StandardError => e
    puts "Error: #{e}\nError Line: #{line}"
  end
end

unique_classes.uniq!

result['classes'] = IORegClass.values.map(&:to_h)

File.write(IOREG_DATA_FILE, result.to_yaml)
