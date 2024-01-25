# frozen_string_literal: true

DEFAULT_APPLE_DATA_SHARE = T.let(File.join(File.dirname(__FILE__), '../share/'), String)

# Base Namespace for AppleData gem
module AppleData
  def get_data(file)
    YAML.load_file(File.join(@apple_data, file))
  end

  def self.data_location=(location)
    @apple_data = location
  end

  def self.data_location
    @apple_data || DEFAULT_APPLE_DATA_SHARE
  end
end

require 'apple_data/data_file'
require 'apple_data/boot_args'
require 'apple_data/fdr'
require 'apple_data/ioreg'
require 'apple_data/macho'
require 'apple_data/lockdown'
require 'apple_data/keybag'
