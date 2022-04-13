#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'

CORES_DATA = YAML.load_file File.join(File.dirname(__FILE__), '..', '_data', 'cores.yaml')

def find_chip_board(product_id)
  CORES_DATA['chip_ids'].each do |chip_id, chip|
    chip['boards'].each do |board_id, board|
      return { chip: '%04X'.format(chip_id), board: '%02X'.format(board_id) } if board['product_id'] == product_id
    end
  end

  nil
end

TYPE_MAP = {
  'LLB' => 'illb',
  'SEPFirmware' => 'sepi',
  'iBEC' => 'ibec',
  'iBoot' => 'ibot',
  'iBSS' => 'ibss'
}.freeze

DESCRIPTORS = %w[Version Build Device Codename Baseband DownloadURL].freeze

IGNORE_VALUES = ['Not Encrypted', 'Unknown'].freeze

KEY_VALUE_PAIR = /^\s\|\s(\w+)\s+=\s(.*)$/

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

puts get_mediawiki_data(File.read('/Users/rickmark/Sites/sample.txt'))
