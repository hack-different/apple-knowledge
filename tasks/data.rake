# frozen_string_literal: true

require_relative '../lib/common'

desc 'validate data directory'
task :validate do
  failed = false
  path = File.join(DATA_DIR, '**', '*.yaml')

  Dir.glob(path) do |file|
    data = YAML.load_file file
    failed = true unless data.is_a? Hash
  rescue StandardError
    failed = true
  end

  raise if failed
end
