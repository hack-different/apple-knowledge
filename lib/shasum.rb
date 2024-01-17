# frozen_string_literal: true

# Parser for output of `shasum` command
class SHASum
  SHASUM_LINE = /^([0-9a-fA-F]*)\s+(\S+)$/m

  def self.shasum_type?(input)
    case input.length
    when 32
      'md5'
    when 40
      'sha1'
    when 56
      'sha2-224'
    when 64
      'sha2-256'
    when 96
      'sha2-384'
    when 128
      'sha2-512'
    else
      'unknown'
    end
  end

  attr_accessor :sums

  def initialize(content)
    @sums = {}
    content.scan(SHASUM_LINE).each do |match|
      @sums[match[1]] = match[0]
    end
  end

  def self.from_file(path)
    new(File.read(path))
  end

  def update_collection(collection)
    @sums.each do |filename, hash|
      entry = collection.ensure_key filename, description: false
      entry['hashes'] ||= {}
      entry['hashes'][SHASum.shasum_type?(hash)] = hash
    end
  end
end
