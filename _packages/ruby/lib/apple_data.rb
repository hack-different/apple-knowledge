# frozen_string_literal: true

require 'apple_data/boot_args'
require 'apple_data/fdr'
require 'apple_data/ioreg'
require 'apple_data/macho'
require 'apple_data/lockdown'

APPLE_DATA_SHARE = T.let(File.join(File.dirname(__FILE__), '../share/'), String)

def get_data(file)
  YAML.load_file(File.join(APPLE_DATA_SHARE, file))
end
