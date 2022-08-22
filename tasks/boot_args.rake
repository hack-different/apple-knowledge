# frozen_string_literal: true

require_relative '../lib/xnu_source'

namespace :data do
  namespace :boot_args do
    desc 'update boot-args from XNU source tree'
    task :scan_xnu_source, [:xnu_directory] do |_task, args|
      data_file = DataFile.new 'boot_args'

      boot_args_collection = data_file.collection :boot_args

      source_tree = XNUSource.new args[:xnu_directory]

      source_tree.each_source_file do |file_name, source|
        discovered_args = source.scan(XNUSource::TUNABLE) + source.scan(XNUSource::PARSE_ARGN)
        discovered_args.each do |call_site|
          puts "#{file_name} => #{call_site[0]}"
          boot_args_collection.ensure_key call_site[0]
        end
      end

      data_file.save
    end
  end
end
