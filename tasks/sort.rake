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

desc 'sort everything'
task :sort do
  path = File.join(DATA_DIR, '**', '*.yaml')
  Dir.glob(path) do |file|
    YAML.load_file file
  end
end

desc 'sort single collection in data file'
task :sort_collection, [:data_file, :collection] do |_task, args|
  args[:collection] ||= args[:data_file]
  data_file = DataFile.new args[:data_file]
  collection = data_file.collection args[:collection]
  collection.sort
  data_file.save
end
