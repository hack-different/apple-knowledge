# frozen_string_literal: true

# launch jekyll
def jekyll(command)
  result = sh 'jekyll', command
  raise unless result
end

desc 'Build for deployment (but do not deploy)'
task :jekyll do
  jekyll('build')
end
