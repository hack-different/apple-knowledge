# frozen_string_literal: true

require 'multihashes'
require 'multibases'
require 'base_x'

# Helper class to create CIDv1 strings from raw SHA2-256 hashes
module CID
  # CIDv1 Base32 alphabet (RFC 4648)

  # Encodes a raw SHA2-256 hex string into a CIDv1 string
  # @param sha256_hex [String] The 64-character hex string
  # @return [String] The CIDv1 string (starting with 'b')
  def self.from_hex(hex, algo = 'sha2-256')
    # 1. Convert hex to raw bytes
    # binary_hash = [hex].pack('H*')

    # 2. Create Multihash (sha2-256 is 0x12)
    # Multihash format: <code: 0x12><length: 0x20><hash_bytes>
    multihash = Multihashes.encode(hex, algo)

    cid_binary = [0x01, 0x70].pack('CC') + multihash

    Multibases.pack('base58btc', cid_binary).map(&:chr).join
  end
end
