# frozen_string_literal: true

require_relative '../lib/common'

namespace :data do
  namespace :baseband do
    desc 'extract all baseband firmwares to tmp'
    task :extract, [:directory] do |_task, args|
      unless File.directory?(args[:directory])
        print "#{args[:directory]} is not a regular directory"
        exit(-1)
      end

      Dir[File.join(args[:directory], '*.ipsw')].each do |ipsw|
        IPSW.new ipsw
      end
    end
  end
end
