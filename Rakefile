#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler'

Bundler.setup :development

require 'yaml'
require 'active_support/all'
require 'kramdown'
require 'octokit'
require 'json'

BASE_PATH = File.dirname(__FILE__)

GITHUB_REPO = %r{https://github\.com/([.\-_a-zA-Z0-9]+)/([.\-_a-zA-Z0-9]+)}

# KramdownVisitor is a helper class to visit the nodes in a Markdown/Kramdown document in the repository.
# You are able to specify the types of element you would like to restrict to.
class KramdownVisitor
  attr_accessor :visitor, :types

  def initialize(types = nil)
    self.types = types
  end

  def visit(element, &visitor)
    visitor.call(element) if types&.include?(element.type)

    element.children.each { |e| visit(e, &visitor) }
  end
end

def sort_yaml(file, key)
  path = File.join(BASE_PATH, '_data', "#{file}.yaml")
  items = YAML.load_file path

  items.sort_by! { |item| item[key.to_s] }

  File.write(path, items.to_yaml)
end

namespace :sort do
  desc 'sort and unique all NVRAM variables'
  task :nvram do
    sort_yaml 'nvram', :name
  end

  desc 'sort and unique all LaunchD services'
  task :services do
    sort_yaml 'services', :name
  end

  desc 'sort and unique all MobileAsset URLs'
  task :mobile_assets do
    sort_yaml 'mobile_assets', :url
  end

  desc 'sort Apple 4CCs'
  task :four_cc do
    sort_yaml '4cc', :code
  end
end

namespace :stubs do
  desc 'create format stubs'
  task :formats do
    Dir.glob(File.join(BASE_PATH, '_data/*.yaml')) do |file|
      format_name = File.basename(file).delete_suffix '.yaml'

      document_name = File.join(BASE_PATH, "formats/#{format_name}.md")

      File.write(document_name, "# #{format_name}\n") unless File.exist? document_name
    end
  end
end

desc 'sort everything'
task sort: ['sort:nvram', 'sort:services', 'sort:mobile_assets', 'sort:four_cc']

desc 'do all precommit tasks'
task precommit: ['sort']

desc 'update credits file from all repos'
task :credits do
  document = Kramdown::Document.new(File.read(File.join(BASE_PATH, 'README.md')))
  visitor = KramdownVisitor.new [:a]
  links = ['hack-different/apple-knowledge']

  visitor.visit(document.root) do |element|
    match = GITHUB_REPO.match(element.attr['href'])
    links << "#{match[1]}/#{match[2]}" if match
  end

  links.delete 'papers-we-love/papers-we-love'

  github = Octokit::Client.new(access_token: ENV['HOMEBREW_GITHUB_API_TOKEN'])
  credits = {}

  links.each do |repo|
    credits[repo] = { 'contributors' => github.contributors(repo).map { |c| c.to_h.stringify_keys } }
  rescue Octokit::Forbidden
    # TODO: GitHub won't work when its a fork of something large (like linux) - we could grab the org members
    # in leau which is usually what is meant
    break
  end

  puts credits.inspect

  File.write(File.join(BASE_PATH, '_data', 'credits.yaml'), credits.to_yaml)
end

desc 'convert to JSON'
task :json do
  yaml_glob = File.join(BASE_PATH, '_data', '*.yaml')
  Dir.glob(yaml_glob) do |file|
    new_file = File.realdirpath(file).to_s.sub('.yaml', '.json')
    data = YAML.load_file file
    File.write(new_file, JSON.dump(data))
  end
end
