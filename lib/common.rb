# typed: true
# frozen_string_literal: true

require 'bundler/setup'

require 'active_support'
require 'active_support/core_ext'
require 'kramdown'
require 'octokit'
require 'json'
require 'cfpropertylist'
require 'yaml'
require 'set'
require 'macho'
require 'faraday'
require 'plist'
require 'uri'
require 'zip'
require 'openssl'
require 'base64'
require 'digest'
require 'awesome_print'
require 'zlib'
require 'byebug'
require 'pry'

BASE_PATH = File.expand_path('..', __dir__) unless defined? BASE_PATH

DATA_DIR = File.realdirpath File.join(BASE_PATH, '_data')
TMP_DIR = File.join(BASE_PATH, 'tmp')

SCHEMAS_DIR = File.join(BASE_PATH, '_schema')

# Represents a DataFile element collection, which is a hash of uniquely identified entries with a hash for a value.
# The hash will contain 'description' as a first element for human annotation
class DataFileCollection
  def initialize(data_file, collection_name)
    @data_file = data_file
    @collection_name = collection_name.to_s
    @data_file.data[@collection_name] ||= {}
    @collection_data = data_file.data[@collection_name]
  end

  def sort
    @collection_data = @collection_data.sort_by { |key, _value| to_sort_key(key) }.to_h
    @data_file.data[@collection_name] = @collection_data
  end

  def each(&)
    @collection_data.each(&)
  end

  def map
    @collection_data.keys.map do |key|
      yield key, @collection_data[key]
    end
  end

  def ensure_key(key, description: true)
    key = key.to_s if key.is_a? Symbol
    @collection_data[key] ||= {}
    value = @collection_data[key]
    value['description'] ||= nil if description
    value
  end

  private

  def to_sort_key(key)
    case key
    when Symbol
      key.to_s.downcase
    when String
      key.downcase
    else
      key
    end
  end
end

# Base class for all data files
class DataFile
  attr_reader :data

  def initialize(*parts)
    @parts = parts
    @collections = {}
    load_file(*parts)
    ensure_metadata
  end

  def load_file(*parts)
    parts[-1] = "#{parts[-1]}.yaml" unless parts[-1].ends_with? '.yaml'
    @filename = File.join(DATA_DIR, File.join(*parts))
    @data = {}
    @data = YAML.load_file @filename if File.exist? @filename
  end

  def save!
    save_data data
  end

  def save
    save!
  end

  def collection(name)
    @collections[name.to_s] ||= DataFileCollection.new(self, name)
  end

  private

  def save_data(data)
    File.write(@filename, data.to_yaml)
  end

  def ensure_metadata
    @data['metadata'] ||= {}
    @data['metadata'].reverse_merge!({ 'description' => nil, 'credits' => [] })
  end
end

SCHEMAS = File.join(SCHEMAS_DIR, '*.rb')

Dir.glob(SCHEMAS).each do |schema|
  require schema
end

def find_chip_board(product_id)
  CORES_DATA.collection(:chip_ids).each do |chip_id, chip|
    chip['boards'].each do |board_id, board|
      return [format('%04X', chip_id), format('%02X', board_id)] if board['product_id'] == product_id
    end
  end

  nil
end

CORES_DATA = DataFile.new 'cores'
