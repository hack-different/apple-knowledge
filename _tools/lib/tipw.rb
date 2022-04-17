#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'common'
require 'mediawiki_api'

# Module for interacting with theiphonewiki.com
module TIPW
  SYNC_DATAFILE = DataFile.new 'tipw_sync'
  CLIENT = MediawikiApi::Client.new 'https://www.theiphonewiki.com/w/api.php'
  DESCRIPTORS = %w[Version Build Device Codename Baseband DownloadURL].freeze

  IGNORE_VALUES = ['Not Encrypted', 'Unknown'].freeze

  KEY_VALUE_PAIR = /^\s\|\s(\w+)\s+=\s(.*)$/

  def self.get_pages_in_category(category_name)
    continue = true
    results = []

    while continue
      args = {
        list: :categorymembers,
        cmtitle: category_name,
        cmlimit: 500
      }
      args[:cmcontinue] = continue unless continue.is_a? TrueClass
      pages = CLIENT.query args

      results.append(*pages.data['categorymembers'])
      puts "Added #{pages.data['categorymembers'].length} items"
      continue = pages['continue'] ? pages['continue']['cmcontinue'] : false
    end

    results
  end

  def self.get_page_content(title)
    CLIENT.get_wikitext title
  end
end

module TIPW
  # A object representing a parsed TIPW firmware key page
  class TIPWKeyPage
    def clean_result(dict)
      dict.each do |key, value|
        dict.delete key if value.is_a?(Hash) && (value.keys == ['filename'])
      end

      dict.transform_keys! do |key|
        TYPE_MAP[key] || key
      end

      dict.reject! { |key, _value| DESCRIPTORS.include? key }
    end

    def append_key(result, name, type, value)
      result[name] ||= {}
      result[name][type.downcase] = value unless IGNORE_VALUES.include?(value)
    end

    def append_keybag(result, name, keybag)
      result[name] ||= {}
      result[name]['keybags'] = {
        'production' => {
          'encrypted_iv' => keybag[0..31],
          'encrypted_key' => keybag[2][32..]
        }
      }
    end

    def process_pairs(pairs)
      pairs.each do |key, value|
        case key
        when *DESCRIPTORS
          next
        when /(.*)KBAG/
          append_keybag result, Regexp.last_match(1), match[2]
        when /(.*)(Key|IV)/
          append_key result, Regexp.last_match(1), Regexp.last_match(2), match[2]
        else
          result[key] ||= { 'filename' => value }
        end
      end

      result
    end

    def get_mediawiki_data(text)
      pairs = text.lines.map { |line| KEY_VALUE_PAIR.match line }.compact.map { |match| { match[1] => match[2] } }

      dict = process_pairs pairs

      device = find_chip_board(dict['Device'])

      build_id = dict['Build']

      { device[:chip] => { device[:board] => { build_id => dict } } }
    end
  end
end
