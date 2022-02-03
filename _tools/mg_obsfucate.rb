#!/usr/bin/env ruby
# frozen_string_literal: true

require 'base64'
require 'digest'

hashed = Digest::MD5.digest "MGCopyAnswer#{ARGV[0]}"

puts Base64.encode64(hashed).delete('=')
