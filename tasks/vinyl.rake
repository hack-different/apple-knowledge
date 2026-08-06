# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

def decode_profile(file)
  data = OpenSSL::ASN1.decode package.read(file)

  OpenSSL::X509::Certificate.new data.to_a.last.to_der
end

namespace :data do
  desc 'Extracts the unique device IDs from a Vinyl (eSIM) example'
  task :vinyl do |example|
    package = Zip::File.open(example)

    ids = []
    profiles = []

    package.each do |file|
      ids << file.name.split('/')[0]
      profiles << file if file.name.ends_with?('profile.bin')
      next if file.directory?

      package.read(file)
    end

    ids.uniq!
  end
end
