# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

namespace :data do
  task :vinyl do |example|
    package = Zip::File.open(example)

    ids = []
    profiles = []

    package.each do |file|
      ids << file.name.split('/')[0]
      profiles << file if file.name.ends_with?('profile.bin')
      next if file.directory?

      data = package.read(file)
      puts "File #{file.name}: #{OpenSSL::Digest::SHA256.hexdigest(data)}"
    end

    ids.uniq!

    puts "IDs: #{ids.inspect}"

    def decode_profile(file)
      puts "Handling File: #{file.name}"
      data = OpenSSL::ASN1.decode package.read(file)

      certificate = OpenSSL::X509::Certificate.new data.to_a.last.to_der
      puts certificate.public_key.to_text
    end
  end
end
