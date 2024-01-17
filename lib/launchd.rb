# frozen_string_literal: true

require_relative 'common'

# General constants and utility functions for handling launchd config data
module LaunchD
  OS_VERSION_PATHS = %w[System/Library/CoreServices/BridgeVersions.plist
                        System/Library/CoreServices/SystemVersion.plist].freeze
  XNU_RELATIVE_PATHS = %w[Library/LaunchAgents Library/LaunchDaemons System/Library/LaunchAgents
                          System/Library/LaunchDaemons].freeze
  OS_NAME = %w[macOS iOS padOS bridgeOS audioOS watchOS].freeze

  def self.compose_os_info(mount_point)
    version_files = LaunchD::OS_VERSION_PATHS.map do |path|
      File.join(mount_point, path)
    end
    version_files = version_files.select { |file| File.exist? file }

    versions_data = version_files.map do |version_file|
      CFPropertyList.native_types(CFPropertyList::List.new(file: version_file).value)
    end.reduce(&:merge).transform_keys(&:underscore)

    { os_version: versions_data, services: [] }.stringify_keys
  end

  def self.map_service_to_hash(service)
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

  def self.map_services_to_hash(output_data, services)
    services.each do |service|
      puts "Service Label: #{service['Label']}"

      output_data['services'] << map_service_to_hash(service).stringify_keys
    end

    output_data
  end

  def self.create_output(mount_path)
    mapped_paths = XNU_RELATIVE_PATHS.map { |path| File.join(mount_path, path) }.select { |dir| Dir.exist? dir }
    service_units = mapped_paths.flat_map { |path| Dir.glob(File.join(path, '*.plist')) }
    services = service_units.map { |unit| CFPropertyList.native_types(CFPropertyList::List.new(file: unit).value) }

    map_services_to_hash(compose_os_info(mount_path), services)
  end
end
