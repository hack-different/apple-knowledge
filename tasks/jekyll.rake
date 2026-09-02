# frozen_string_literal: true

# launch jekyll
def jekyll(command)
  result = sh 'jekyll', command
  raise unless result
end

namespace :jekyll do
  desc 'Build for deployment (but do not deploy)'
  task :jekyll do
    jekyll('build')
  end

  desc 'Run Jekyll local server'
  task :serve do
    sh 'bundle exec jekyll serve'
  end
end
