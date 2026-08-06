#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

BASE_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(BASE_PATH, 'lib'))

require 'common'

UPDATE_TASKS = %w[tipw:categories tipw:pages tipw:ipsws tipw:keydb tipw:keys data:mobile_assets
                  data:ipsw:manifests:download data:ipsw:manifests data:ipsw:total_order sort].freeze

Rake.add_rakelib 'tasks'

RuboCop::RakeTask.new

desc 'do all precommit tasks'
task precommit: %i[sort]

RSpec::Core::RakeTask.new(:spec)

desc 'default build task'
task default: ['rubocop:autocorrect', :spec, :precommit]

desc 'Perform all automated updates'
task :update do
  UPDATE_TASKS.each do |task|
    Rake::Task[task].invoke
  end
end
