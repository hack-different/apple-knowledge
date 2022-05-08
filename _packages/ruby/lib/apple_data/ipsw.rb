# frozen_string_literal: true

require 'zip'
require 'cfpropertylist'

# Represents an IPSW on disk and provides helper access
class IPSW
  def initialize(path)
    @path = path
    @zip = Zip::File.open(@path)
    @manifest = CFPropertyList.guess(@zip.get_entry('BuildManifest.plist').get_input_stream.read)
  end

  def baseband_files
    result = []
    @manifest['BuildIdentities'].each do |identity|
      identity['Manifest'].each do |key, value|
        result << value if key == 'BasebandFirmware'
      end
    end
    result
  end

  def img4_files; end
end
