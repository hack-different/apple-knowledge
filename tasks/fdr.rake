# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

namespace :data do
  task :fdr, [:example_file] do |_task, args|
    data = FDRData.new

    input = Plist.parse_xml args[:example_file]

    input['VerifiedData'].each do |entry|
      entry.each_key do |key|
        data.ensure_property key
      end
    end

    input['VerifiedProperties'].each do |entry|
      entry.each_key do |key|
        data.ensure_property key
      end
    end

    data.save!
  end
end
