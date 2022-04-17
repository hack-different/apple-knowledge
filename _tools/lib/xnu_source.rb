# frozen_string_literal: true

# A class representing a XNU source tree
class XNUSource
  PARSE_ARGN = /PE_parse_boot_argn\(\s*"([^"]+)"/m
  TUNABLE = /TUNABLE\(\w+,\s*\w+,\s*"([^"]+)",\s*\w+\)/m
  SUPPORTED_FILE_EXTENSIONS = %w[c h m mm cpp hpp hxx cxx].freeze

  def initialize(path)
    raise "#{path} is not a directory" unless File.directory? path

    @path = path
  end

  def each_source_file
    Dir.glob(File.join(@path, '**', '*')).each do |entry|
      next if File.directory? entry
      next unless SUPPORTED_FILE_EXTENSIONS.include? File.extname(entry).delete_prefix('.')

      yield entry.delete_prefix(@path), File.read(entry)
    rescue StandardError => e
      puts "Error in processing file #{entry}.  Inner error:\n\n#{e}"
    end
  end
end
