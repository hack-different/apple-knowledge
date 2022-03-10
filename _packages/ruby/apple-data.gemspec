# frozen_string_literal: true

require_relative 'lib/apple_data/version'

Gem::Specification.new do |s|
  s.name        = 'apple-data'
  s.version     = AppleData::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Static data from https://docs.hackdiffe.rent'
  s.description = 'This package includes machine readable data about Apple platforms maintained by hack-different'
  s.authors     = ['Rick Mark']
  s.email       = 'rickmark@outlook.com'
  s.files       = Dir['share/**/*.yaml'] + Dir['lib/**/*']
  s.homepage    = 'https://docs.hackdiffe.rent'
  s.required_ruby_version = '>= 3.1'
  s.metadata = { 'source_code_uri' => 'https://github.com/hack-different/apple-knowledge',
                 'rubygems_mfa_required' => 'true' }
  s.add_development_dependency 'pathutil'
end
