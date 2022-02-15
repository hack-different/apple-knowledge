#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/common'

data = FDRData.new

input = Plist.parse_xml ARGV[0]

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
