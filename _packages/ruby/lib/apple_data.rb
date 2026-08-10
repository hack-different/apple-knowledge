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
    loader.inflector.inflect(
      'dsl' => 'DSL',
      'img4' => 'IMG4',
      'pki' => 'PKI',
      'asn1_definition' => 'ASN1Definition'
    )
    loader.setup

    loader.eager_load_dir(File.join(__dir__, 'apple_data/schemas'))
  end

  DEFAULT_APPLE_DATA_SHARE = File.join(File.dirname(__FILE__), '../share/')

  def self.get_data(file)
    YAML.load_file(File.join(AppleData.data_location, file))
  end

  def self.get_path(*parts)
    File.join(AppleData.data_location, *parts)
  end

  def self.data_location=(location)
    @data_location = location
  end

  def self.data_location
    @data_location ||= AppleData::DEFAULT_APPLE_DATA_SHARE
  end
end
