#!/usr/bin/env ruby
# frozen_string_literal: true

# typed: ignore

require_relative 'lib/common'

VYNAL_PACKAGE = ARGV[0]

PACKAGE = Zip::File.open(VYNAL_PACKAGE)

ids = []
profiles = []

PACKAGE.each do |file|
  ids << file.name.split('/')[0]
  profiles << file if file.name.ends_with?('profile.bin')
  next if file.directory?

  data = PACKAGE.read(file)
  puts "File #{file.name}: #{OpenSSL::Digest::SHA256.hexdigest(data)}"
end

ids.uniq!

puts "IDs: #{ids.inspect}"

def decode_profile(file)
  puts "Handling File: #{file.name}"
  data = OpenSSL::ASN1.decode PACKAGE.read(file)

  certificate = OpenSSL::X509::Certificate.new data.to_a.last.to_der
  puts certificate.public_key.to_text
end

# profiles.each { |p| decode_profile(p) }
