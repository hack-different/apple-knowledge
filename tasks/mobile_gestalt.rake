# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

namespace :data do
  task :mobile_gestalt do
    def obfuscate(input_key)
      hashed = Digest::MD5.digest "MGCopyAnswer#{input_key}"

      Base64.encode64(hashed).delete('=').squish
    end

    data_file = DataFile.new 'mobile_gestalt'

    data_file.data['known_keys'] ||= {}
    data_file.data['known_keys'].each do |key|
      key['obfuscated'] = obfuscate(key['question'])
      key['type'] = nil
    end

    data['known_keys'].sort_by! { |q| q['question'].downcase }

    data_file.save
  end
end
