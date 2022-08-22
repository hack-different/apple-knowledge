# frozen_string_literal: true

# typed: ignore

require_relative '../lib/launchd'

namespace :data do
  desc 'update launchd services from OS'
  task :launchd do |mount_point, os_type|
    os_file_name = "services_#{os_type}_#{LaunchD.compose_os_info(mount_point)['os_version']['product_version']}"
    data_file = DataFile.new 'launchd', os_file_name

    data_file.save
  end
end
