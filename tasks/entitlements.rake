# frozen_string_literal: true

require_relative '../lib/common'

namespace :data do
  namespace :entitlements do
    desc 'scan directory of plists and add to entitements database'
    task :scan, [:directory] do |_task, args|
      data = DataFile.new :entitlements
      def_elist = data.collection :entitlements
      Dir[File.join(args[:directory], '**/*.plist')].each do |plist|
        print("Reading Data File: #{plist}\n")
        elist = CFPropertyList::List.new file: plist

        elist.value.value.each do |key, value|
          entry = def_elist.ensure_key key
          entry['types'] ||= []
          entry['types'] << 'boolean' if !entry['types'].include?('boolean') && [true, false].include?(value.value)
          entry['types'] << 'array' if !entry['types'].include?('array') && value.value.is_a?(Array)
        end
      end
      data.save
    end
  end
end
