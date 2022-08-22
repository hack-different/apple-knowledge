# frozen_string_literal: true

require_relative 'common'
require 'digest'
require 'zip'

# Helper class to create merkle tree representation of a Zip file
class MerkleTree
  def initialize(file)
    @file = file
    @files = []
  end

  def scan
    @hash = Digest::SHA256.file(@file).hexdigest
    Zip::File.open @file do |zip|
      zip.each do |entry|
        stream = entry.get_input_stream

        @files << if stream == Zip::NullInputStream
                    { 'directory' => entry.name }
                  else
                    file_entry(entry, stream)
                  end
      end
    end
  end

  def to_h
    # TODO: hashes ambiguous between defalted and original
    {
      'filename' => File.basename(@file),
      'hashes' => {
        'sha2-256' => @hash
      },
      'files' => @files
    }
  end

  private

  def file_entry(entry, stream)
    result = {
      'name' => entry.name,
      'size' => entry.size,
      'compressed_size' => entry.compressed_size,
      'hashes' => file_hashes(stream)
    }

    update_time result, entry
    update_permissions result, entry
    update_metadata result, entry

    result
  end

  def file_hashes(stream)
    digest = Digest::SHA256.new
    buffer = ''

    digest.update buffer while stream.read(16_384, buffer)

    {
      'sha2-256' => digest.hexdigest
    }
  end

  def update_time(result, entry)
    if entry.extra.key? 'OldUnix'
      old_unix = entry.extra['OldUnix']
      result['access_time'] = old_unix.atime
      result['modify_time'] = old_unix.mtime
      result['uid'] = old_unix.uid unless old_unix.uid.zero?
      result['gid'] = old_unix.gid unless old_unix.gid.zero?
    else
      result['access_time'] = result['modify_time'] = entry.time.to_i
      result['uid'] = entry.unix_uid if entry.unix_uid
      result['gid'] = entry.unix_gid if entry.unix_gid
    end
  end

  def update_permissions(result, entry)
    # TODO: proper delta file attributes
    if entry.unix_perms == 0o755
      unless entry.external_file_attributes == 2_179_809_280
        result['external_file_attributes'] =
          entry.external_file_attributes
      end
    else
      unless entry.external_file_attributes == 2_175_025_152
        result['external_file_attributes'] =
          entry.external_file_attributes
      end
    end
    result['mode'] = entry.unix_perms.to_s(8) unless entry.unix_perms == 644
  end

  def update_metadata(result, entry)
    version = entry.instance_variable_get :@version
    result['version'] = version unless version == 21
    required_version = entry.instance_variable_get :@version_needed_to_extract
    result['required_version'] = required_version unless required_version == 20

    unless entry.internal_file_attributes.zero?
      result['internal_file_attributes'] =
        entry.internal_file_attributes
    end

    result['comment'] = entry.comment unless entry.comment.blank?
    unless entry.compression_method == Zip::Entry::DEFLATED
      result['compression_method'] =
        entry.compression_method
    end
    result['flag'] = entry.gp_flags unless entry.gp_flags == 8
  end
end
