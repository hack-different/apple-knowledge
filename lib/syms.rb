# frozen_string_literal: true

SYM_FILES = [
  '/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_x86_64.map',
  '/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_arm64e.map',
  '/Users/rickmark/bins.txt'
].freeze

FRAMEWORK_FILES = [
  '/Users/rickmark/frameworks.txt'
].freeze

XPC_FILES = [
  '/Users/rickmark/xpc.txt'
].freeze

IGNORE_PATHS = [
  '/Users/rickmark/OldM3'
].freeze

OUT = '/Users/rickmark/Sites/symbol_land'

PATH_MATCH = %r{^(/.+)$}

require 'digest'
require 'cfpropertylist'
require 'fileutils'
require 'pathname'
require 'yaml'

ARCHES = [nil, 'i386', 'x86_64', 'x86_64h', 'arm64', 'arm64e'].freeze

COMMON_OPTS = '-printDemangling -lazy -deepSignature -privateData -fullSourcePath -w'

def do_read_symbols(arch, path, output_path, type = nil)
  hash = Digest::MD5.hexdigest(path)
  puts "Reading Symbols for #{path} using #{arch}"

  if type
    type = ".#{type}" unless type.start_with? '.'
  else
    type = ''
  end

  data = if arch.nil?
           `symbols -arch "#{arch}" #{COMMON_OPTS} #{path}`
         else
           `arch -arch #{arch} symbols -arch "#{arch}" #{COMMON_OPTS} "#{path}"`
         end
  file = File.join(output_path, "#{hash}_#{File.basename(path)}#{type}")

  File.write(file, data) unless data.empty?
end

def path_ignored?(path)
  path_object = Pathname.new(path)
  IGNORE_PATHS.map do |ignore|
    path_object.fnmatch? ignore
  end.any?
end

ARCHES.each do |arch| # rubocop:disable Metrics/BlockLength
  output_path = File.join(OUT, ENV.fetch('USER', 'unknown'), (arch || 'host'))
  FileUtils.mkdir_p(output_path)

  FRAMEWORK_FILES.each do |framework_file|
    File.open(framework_file).readlines.map(&:chomp).each do |framework|
      next if path_ignored? framework

      framework_basename = File.basename(framework, '.framework')

      binary_path = File.join(framework, 'Versions/Current', framework_basename)

      if File.exist? binary_path
        do_read_symbols arch, binary_path, output_path, 'framework'
      else
        tbd_path = File.join(framework, "#{framework_basename}.tbd")
        if File.exist? tbd_path
          tbd_data = YAML.load_file(tbd_path)
          install_name = tbd_data['install-name']
          puts "Using Framework Install Name: #{install_name}"

          do_read_symbols arch, install_name, output_path, 'framework' if install_name
        end
      end
    end
  end

  XPC_FILES.each do |xpc_file|
    File.open(xpc_file).readlines.map(&:chomp).each do |xpc|
      next if path_ignored? xpc

      base_name = File.basename(xpc, '.xpc')

      begin
        plist_path = File.join(xpc, 'Contents/Info.plist')
        puts "Reading XPC Plsit from: #{plist_path}"
        plist = CFPropertyList::List.new(file: plist_path)
        data = CFPropertyList.native_types(plist.value)

        name = data['CFBundleName']
      rescue StandardError
        name = base_name
      end

      name ||= base_name

      binary_path = File.join(xpc, 'Contents/MacOS', name)

      do_read_symbols arch, binary_path, output_path, 'xpc'
    end
  end

  SYM_FILES.each do |sym_file|
    File.open(sym_file).readlines.map(&:chomp).each do |line|
      next unless PATH_MATCH.match(line)
      next if path_ignored? line

      do_read_symbols arch, line, output_path
    end
  end
end
