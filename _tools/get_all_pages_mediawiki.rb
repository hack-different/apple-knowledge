#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'mediawiki_api'
require 'yaml'

client = MediawikiApi::Client.new 'https://www.theiphonewiki.com/w/api.php'

CATEGORY_NAME = 'Category:All_Key_Pages'

ITEMS = [].freeze

pages = client.query list: :categorymembers, cmtitle: 'Category:All_Key_Pages', cmlimit: 500
ITEMS.append(*pages.data['categorymembers'])
puts "Added #{pages.data['categorymembers'].length} items"

while pages['continue']
  pages = client.query list: :categorymembers, cmtitle: 'Category:All_Key_Pages', cmlimit: 500,
                       cmcontinue: pages['continue']['cmcontinue']
  ITEMS.append(*pages.data['categorymembers'])
  puts "Added #{pages.data['categorymembers'].length} items"
end

File.write 'pages.txt', ITEMS.to_yaml
