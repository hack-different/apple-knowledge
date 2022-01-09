#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cfpropertylist'
require 'active_support/all'
require 'yaml'

OS_VERSION_PATHS = %w[System/Library/CoreServices/BridgeVersions.plist
                      System/Library/CoreServices/SystemVersion.plist].freeze
XNU_RELATIVE_PATHS = %w[Library/LaunchAgents Library/LaunchDaemons System/Library/LaunchAgents
                        System/Library/LaunchDaemons].freeze
OS_NAME = %w[macOS iOS padOS bridgeOS audioOS watchOS].freeze

puts 'Usage: scan_services.rb <IPSW_ROOT_MOUNT_PATH> <iOS/padOS/bridgeOS/macOS>' if ARGV.length != 2

ROOT_PATH = ARGV[0]

unless OS_NAME.include? ARGV[1]
  puts "Unknown OS type #{ARGV[1]}"
  exit(-1)
end

def compose_os_info
  version_files = OS_VERSION_PATHS.map { |path| File.join(ROOT_PATH, path) }.select { |file| File.exist? file }

  versions_data = version_files.map do |version_file|
    CFPropertyList.native_types(CFPropertyList::List.new(file: version_file).value)
  end.reduce(&:merge).transform_keys(&:underscore)

  { os_version: versions_data, services: [] }.stringify_keys
end

OS_TYPE = File.join(File.dirname(__FILE__), '..', '_data', 'launchd',
                    "services_#{ARGV[1]}_#{compose_os_info['os_version']['product_version']}.yaml")

def map_service_to_hash(service)
  {
    label: service['Label'],
    enable_pressured_exit: service['EnablePressuredExit'],
    enable_transactions: service['EnableTransactions'],
    keep_alive: service['KeepAlive'],
    mach_services: service['MachServices'],
    launch_events: service['LaunchEvents'],
    program_arguments: service['ProgramArguments'],
    publishes_events: service['PublishesEvents'],
    posix_spawn_type: service['POSIXSpawnType'],
    remote_services: service['RemoteServices']
  }
end

def map_services_to_hash(output_data, services)
  services.each do |service|
    puts "Service Label: #{service['Label']}"

    output_data['services'] << map_service_to_hash(service).stringify_keys
  end

  output_data
end

def create_output
  mapped_paths = XNU_RELATIVE_PATHS.map { |path| File.join(ROOT_PATH, path) }.select { |dir| Dir.exist? dir }
  service_units = mapped_paths.flat_map { |path| Dir.glob(File.join(path, '*.plist')) }
  services = service_units.map { |unit| CFPropertyList.native_types(CFPropertyList::List.new(file: unit).value) }

  YAML.dump(map_services_to_hash(compose_os_info, services))
end

File.write(OS_TYPE, create_output)
