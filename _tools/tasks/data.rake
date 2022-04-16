# frozen_string_literal: true

require_relative '../lib/common'

desc 'validate data directory'
task :validate do
  failed = false
  path = File.join(DATA_DIR, '**', '*.yaml')
  puts "Checking data files in path #{path}"
  Dir.glob(path) do |file|
    puts "Checking file #{file}"
    data = YAML.load_file file
    unless data.is_a? Hash
      puts "Data file #{file} is not a valid hash (#{data.class})"
      failed = true
    end
  rescue StandardError => e
    failed = true
    puts "Error parsing #{file} => #{e}"
  end

  raise if failed
end
