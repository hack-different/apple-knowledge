# frozen_string_literal: true

UPDATE_DOC_URL = 'http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml'

namespace :data do
  desc 'update build data from documentation' do
    response = Faraday.get(UPDATE_DOC_URL)
    update_docs = Plist.parse_xml(response.body)

    builds = {}

    update_docs['Assets'].each do |asset|
      builds[asset['BuildVersion']] ||= {}
      builds[asset['BuildVersion']][asset['Product']] ||= {}
    end
  end
end
