# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

source 'https://rubygems.org'

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
# gem "jekyll", "~> 4.2.1"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.

gem 'jekyll'
gem 'plist'
gem 'toml'

gem 'rbs'

gem 'mootool'

gem 'sorbet-runtime'

gem 'apple-data', path: File.join(File.dirname(__FILE__), '_packages/ruby')

# If you have any plugins, put them here!
# RESOURCE: https://github.com/planetjekyll/awesome-jekyll-plugins
group :jekyll_plugins do
  gem 'jekyll-coffeescript'
  gem 'jekyll-commonmark'
  gem 'jekyll-default-layout'
  gem 'jekyll-gist'
  gem 'jekyll-github-metadata'
  gem 'jekyll-mentions'
  gem 'jekyll-optional-front-matter'
  gem 'jekyll-paginate'
  gem 'jekyll-readme-index'
  gem 'jekyll-relative-links'
  gem 'jekyll-remote-theme'
  gem 'jekyll-seo-tag'
  gem 'jekyll-titles-from-headings'
end

group :development, :test do
  gem 'activerecord'
  gem 'activesupport', require: false
  gem 'awesome_print'
  gem 'base_x'
  gem 'bundle-audit'
  gem 'byebug'
  gem 'CFPropertyList'
  gem 'cid'
  gem 'dotenv-rails'
  gem 'eth', github: 'rickmark/eth.rb', branch: 'ruby4'
  gem 'faraday', '~> 2.5'
  gem 'faraday-retry'
  gem 'google-protobuf'
  gem 'hashie'
  gem 'keccak', github: 'rickmark/keccak.rb', branch: 'ruby4'
  gem 'kramdown'
  gem 'manpages'
  gem 'mdl'
  gem 'mediawiki_api', github: 'rickmark/mediawiki-ruby-api', branch: 'faraday_2'
  gem 'merkle_tree'
  gem 'multibases'
  gem 'multicodecs'
  gem 'multihashes'
  gem 'nokogiri'
  gem 'octokit'
  gem 'overcommit'
  gem 'pathutil'
  gem 'pry'
  gem 'rake'
  gem 'rate_throttle_client'
  gem 'rspec'
  gem 'rspec-rake'
  gem 'rubocop'
  gem 'ruby-macho'
  gem 'sqlite3'
  gem 'steep'
  gem 'tapioca', require: false
  gem 'typeprof'
  gem 'typhoeus'
  gem 'wikicloth'
end

# rubocop:enable Metrics/BlockLength
