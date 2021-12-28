#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'

Bundler.setup :development

require 'yaml'
require 'active_support/all'

BASE_PATH = File.dirname(__FILE__)

def sort_yaml(file, key)
  path = File.join(BASE_PATH, '_data', "#{file}.yaml")
  items = YAML.load_file path

  items.sort_by! { |item| item[key.to_s] }

  File.open(path, 'w') { |output_file| output_file.write(items.to_yaml) }
end

namespace :sort do
  desc 'sort and unique all NVRAM variables'
  task :nvram do
    sort_yaml 'nvram', :name
  end

  desc 'sort and unique all LaunchD services'
  task :services do
    sort_yaml 'services', :name
  end

  desc 'sort and unique all MobileAsset URLs'
  task :mobile_assets do
    sort_yaml 'mobile_assets', :url
  end
end

desc 'sort everything'
task sort: ['sort:nvram', 'sort:services', 'sort:mobile_assets']

desc 'do all precommit tasks'
task precommit: ['sort']
