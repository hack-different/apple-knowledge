# frozen_string_literal: true

require 'openssl'

def print_files_in_patch(patch_file_path)
  parser = OpenSSL::ASN1.decode(File.read(patch_file_path))

  files_node = parser.entries.find { |node| node.tag == 601 }
  files = files_node&.value&.entries || []
  files.each do |node|
    filename_node = node.value.entries.find { |e| e.tag == 500 }
    print("File: #{filename_node.value}\n") if filename_node
  end
end
