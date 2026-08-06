# frozen_string_literal: true

require 'active_support/all'
require 'shale'
require 'zeitwerk'
require 'jsonpath'

# Base Namespace for AppleData gem
module AppleData
  LOADER = Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir(__dir__)
    loader.tag = 'apple-data'
    loader.inflector.tap do |inflector|
      inflector.inflect 'dsl' => 'DSL'
      inflector.inflect 'img4' => 'IMG4'
      inflector.inflect 'pki' => 'PKI'
    end
    loader.setup

    loader.eager_load_dir(File.join(__dir__, 'apple_data/schemas'))
  end

  DEFAULT_APPLE_DATA_SHARE = File.join(File.dirname(__FILE__), '../share/')

  def get_data(file)
    YAML.load_file(File.join(@apple_data, file))
  end

  def self.data_location=(location)
    @apple_data = location
  end

  def self.data_location
    @apple_data || AppleData::DEFAULT_APPLE_DATA_SHARE
  end
end
