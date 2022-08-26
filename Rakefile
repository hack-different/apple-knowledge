#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rubocop/rake_task'

BASE_PATH = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(BASE_PATH, 'lib'))

require 'common'

Rake.add_rakelib 'tasks'

RuboCop::RakeTask.new

desc 'do all precommit tasks'
task precommit: %i[sort jekyll]

desc 'default build task'
task default: ['rubocop:auto_correct', :precommit]

desc 'Perform all automated updates'
task :update do
  Rake::Task['credits'].execute
  Rake::Task['sort'].execute
  Rake::Task['data:ipsw:total_order'].execute
end
