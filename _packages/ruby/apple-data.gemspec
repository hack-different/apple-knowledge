# frozen_string_literal: true

require_relative 'lib/apple_data/version'

Gem::Specification.new do |s|
  s.name        = 'apple-data'
  s.version     = AppleData::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Static data files from https://docs.hackdiffe.rent'

  s.description = <<-DESC
    This package includes machine readable data about Apple platforms maintained by hack-different.

    To update the contents of this gem perform a pull request against the `_data` folder of the repository
    at hack-different/apple-knowledge.
  DESC
  s.rdoc_options = ['--main', 'README.md', '--title=Hack Different AppleData']
  s.extra_rdoc_files = [
    'README.md'
  ]
  s.authors     = ['Rick Mark']
  s.email       = 'rickmark@outlook.com'
  s.files       = Dir['share/**/*.yaml'] + Dir['lib/**/*']
  s.homepage    = 'https://docs.hackdiffe.rent'
  s.required_ruby_version = '>= 3.1'
  s.metadata = { 'source_code_uri' => 'https://github.com/hack-different/apple-knowledge' }
end
