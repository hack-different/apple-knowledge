# frozen_string_literal: true

# Base Namespace for AppleData gem
module AppleData
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

require 'apple_data/data_file'
require 'apple_data/factory_data_reset'
require 'apple_data/io_reg'
require 'apple_data/lockdown'
require 'apple_data/keybag'
