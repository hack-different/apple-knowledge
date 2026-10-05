# frozen_string_literal: true

require 'openssl'
require 'fileutils'

namespace :certificates do
  desc 'Rename certificate files based on their Common Name (CN), handling collisions'
  task :rename do
    cert_dir = File.join(__dir__, '..', '_data', 'certificates')

    # Two-pass approach: first compute all renames, then apply them
    renames = []
    seen = {}

    Dir.glob(File.join(cert_dir, '**', '*')).select { |f| File.file?(f) }.sort.each do |file|
      ext = File.extname(file).downcase

      next unless %w[.der .crt .cer .pem].include?(ext)

      raw = File.binread(file)

      # Skip private keys and public keys
      text = raw.force_encoding('UTF-8')
      next if text.valid_encoding? && text.start_with?('-----BEGIN') && !text.include?('BEGIN CERTIFICATE')

      cert = begin
        OpenSSL::X509::Certificate.new(raw)
      rescue OpenSSL::X509::CertificateError
        begin
          pem = "-----BEGIN CERTIFICATE-----\n#{[raw].pack('m')}\n-----END CERTIFICATE-----\n"
          OpenSSL::X509::Certificate.new(pem)
        rescue OpenSSL::X509::CertificateError
          warn "SKIP (not a certificate): #{file}"
          next
        end
      end

      # Extract CN from subject, fall back to OU
      cn_entry = cert.subject.to_a.find { |name, _, _| name == 'CN' }
      cn_entry ||= cert.subject.to_a.find { |name, _, _| name == 'OU' }

      unless cn_entry
        warn "SKIP (no CN or OU): #{file}"
        next
      end

      cn = cn_entry[1]

      # Sanitize CN for filesystem
      sanitized = cn.gsub(%r{[/\\:*?"<>|]}, '_').gsub(/\s+/, ' ').strip

      dir = File.dirname(file)
      key = "#{dir}/#{sanitized}#{ext}"

      seen[key] ||= 0
      seen[key] += 1

      new_name = if seen[key] == 1
                   "#{sanitized}#{ext}"
                 else
                   "#{sanitized}_#{seen[key] - 1}#{ext}"
                 end

      new_path = File.join(dir, new_name)

      renames << [file, new_path] unless file == new_path
    end

    # Apply renames safely: use temp files for sources that are also targets
    sources = renames.to_set(&:first)
    targets = renames.to_set(&:last)
    conflicting = sources & targets

    # First pass: move conflicting sources to temp names
    temp_map = {}
    conflicting.each do |path|
      next unless File.exist?(path)

      temp = "#{path}.tmp_rename"
      FileUtils.mv(path, temp)
      temp_map[path] = temp
    end

    # Update renames to use temp paths for conflicting sources
    renames.each do |pair|
      pair[0] = temp_map[pair[0]] if temp_map.key?(pair[0])
      puts "#{from} -> #{to}"
      FileUtils.mv(from, to)
    end

    puts "\nRenamed #{renames.size} certificate files."
  end
end
