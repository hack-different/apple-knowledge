# frozen_string_literal: true

def sort_yaml(file, key, property = nil)
  path = File.join(BASE_PATH, '_data', "#{file}.yaml")
  items = YAML.load_file path

  if property
    items[property].sort_by! { |item| item[key.to_s].downcase }
  else
    items.sort_by! { |item| item[key.to_s].downcase }
  end

  File.write(path, items.to_yaml)
end

namespace :sort do
  desc 'sort and unique all NVRAM variables'
  task :nvram do
    sort_yaml 'nvram', :name, 'variables'
  end

  desc 'sort and unique all LaunchD services'
  task :services do
    sort_yaml 'services', :name
  end

  desc 'sort and unique all MobileAsset URLs'
  task :mobile_assets do
    sort_yaml 'mobile_assets', :url
  end

  desc 'sort Apple 4CCs'
  task :four_cc do
    sort_yaml '4cc', :code
  end
end

desc 'sort everything'
task sort: ['sort:nvram', 'sort:services', 'sort:mobile_assets', 'sort:four_cc']
