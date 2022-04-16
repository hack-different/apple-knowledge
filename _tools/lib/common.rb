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

SCHEMAS_DIR = File.join(File.dirname(__FILE__), '..', '_schema')

# Base class for all data files
class DataFile
  def initialize(*parts)
    @parts = parts
    load_file(*parts)
    ensure_metadata
  end

  def load_file(*parts)
    parts[-1] = "#{parts[-1]}.yaml" unless parts[-1].ends_with? '.yaml'
    @filename = File.join(DATA_DIR, File.join(*parts))
    @data = {}
    @data = YAML.load_file @filename if File.exist? @filename
  end

  def ensure_metadata; end

  def save_data(data)
    File.write(@filename, data.to_yaml)
  end

  attr_reader :data

  def save!
    save_data data
  end
end

SCHEMAS = File.join(SCHEMAS_DIR, '*.rb')

Dir.glob(SCHEMAS).each do |schema|
  require schema
end
