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
require 'zip'
require 'openssl'
require 'base64'
require 'digest'

DATA_DIR = File.realdirpath File.join(File.dirname(__FILE__), '..', '..', '_data')

SCHEMAS_DIR = File.join(File.dirname(__FILE__), '..', '..', '_schema')

# Represents a DataFile element collection, which is a hash of uniquely identified entries with a hash for a value.
# The hash will contain 'description' as a first element for human annotation
class DataFileCollection
  def initialize(data_file, collection_name)
    data_file.data[collection_name.to_s] ||= {}
    @collection_data = data_file.data[collection_name.to_s]
  end

  def ensure_key(key)
    value = @collection_data[key.to_s] ||= {}
    value['description'] ||= nil
    value
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
