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
require 'sorbet-runtime'
require 'apple_data'

BASE_PATH = File.expand_path('..', __dir__) unless defined? BASE_PATH

DATA_DIR = File.realdirpath File.join(BASE_PATH, '_data')
TMP_DIR = File.join(BASE_PATH, 'tmp')

SCHEMAS_DIR = File.join(BASE_PATH, '_schema')

AppleData.data_location = DATA_DIR

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

  def each_key(&)
    @collection_data.each_key(&)
  end

  def each_value(&)
    @collection_data.each_value(&)
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

SCHEMAS = File.join(SCHEMAS_DIR, '*.rb')

Dir.glob(SCHEMAS).each do |schema|
  require schema
end

def find_chip_board(product_id, chip_type: :ap)
  CORES_DATA.collection(:chip_ids).each do |chip_id, chip|
    current_chip_type = chip['type'] || 'ap'
    next unless current_chip_type == chip_type.to_s

    chip['boards'].each do |board_id, board|
      return [format('%04X', chip_id), format('%02X', board_id)] if board['product_id'] == product_id
    end
  end

  nil
end

CORES_DATA = AppleData::DataFile.new 'cores'
