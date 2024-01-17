#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rubocop/rake_task'

BASE_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(BASE_PATH, 'lib'))

require 'common'

UPDATE_TASKS = %w[tipw:categories tipw:pages tipw:ipsws data:mobile_assets data:ipsw:manifests:download
                  data:ipsw:manifests data:ipsw:total_order sort].freeze

Rake.add_rakelib 'tasks'

RuboCop::RakeTask.new

desc 'do all precommit tasks'
task precommit: %i[sort]

desc 'default build task'
task default: ['rubocop:auto_correct', :precommit]

desc 'Perform all automated updates'
task :update do
  UPDATE_TASKS.each do |task|
    puts "Executing update task: #{task}"
    Rake::Task[task].invoke
  end
end
