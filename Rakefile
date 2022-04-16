#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'rubocop/rake_task'

BASE_PATH = File.dirname(__FILE__)

Rake.add_rakelib '_tools/tasks'

RuboCop::RakeTask.new

desc 'do all precommit tasks'
task precommit: ['rubocop:auto_correct', 'sort']

desc 'default build task'
task default: :precommit
