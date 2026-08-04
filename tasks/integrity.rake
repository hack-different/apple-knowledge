# frozen_string_literal: true

require 'eth'
require 'json'
require 'dotenv/load'
require 'rate_throttle_client'

# Defined values for Ethereum-based blockchain integrity
module Integrity
  # Pseudo response object to make Eth.rb into something that can be used by rate
  # limiting logic
  class Response
    # @return [Integer] Pseudo HTTP status code
    attr_accessor :status

    def self.rate_limit
      new 429
    end

    def self.success
      new 200
    end

    private

    def initialize(status)
      @status = status
    end

    def headers
      { 'RateLimit-Remaining' => '0' }
    end
  end

  def do_request(eth, contract, key, name, value)
    eth.transact contract, 'storeHash', PackageType::IPSW, name, HashType::SHA2_256, value['hashes']['sha2-256'],
                 gas_limit: 15_000_000, sender_key: key
    Response.success
  rescue Eth::Client::RpcError
    Response.rate_limit
  end

  case ENV.fetch('RAKE_ENV', nil)
  when 'test'
    PRIVATE_KEY = [ENV.fetch('TEST_ETHEREUM_PRIVATE_KEY', nil)].pack('H*')
    NODE_URL = ENV.fetch('TEST_ETHEREUM_RPC', nil)
    CONTRACT_ADDRESS = ENV.fetch('TEST_INTEGRITY_CONTRACT', nil)
  else
    PRIVATE_KEY = [ENV.fetch('DEV_ETHEREUM_PRIVATE_KEY', nil)].pack('H*')
    NODE_URL = ENV.fetch('DEV_ETHEREUM_RPC', nil)
    CONTRACT_ADDRESS = ENV.fetch('DEV_INTEGRITY_CONTRACT', nil)
  end

  module PackageType
    IPSW = 0
  end

  module HashType
    MD5 = 0
    SHA1 = 1
    SHA2_224 = 2
    SHA2_256 = 3
    SHA2_384 = 4
    SHA2_512 = 5
    SHA3_224 = 6
    SHA3_256 = 7
    SHA3_384 = 8
    SHA3_512 = 9
    KECCAC_256 = 10
  end
end

desc 'Perform blockchain integrity upload'
task :integrity do
  data_file = AppleData::DataFile.new 'ipsw'
  collection = data_file.collection :ipsw_files
  throttle = RateThrottleClient::ExponentialIncreaseProportionalRemainingDecrease.new

  puts "Connection to Ethereum node: #{NODE_URL}"
  eth = Eth::Client.create(NODE_URL)
  abi_json = File.read(File.join(File.dirname(__FILE__), '../lib/ApplePackageIntegrity.json'))
  contract_abi = JSON.parse(abi_json)
  contract = Eth::Contract.from_abi(name: 'ApplePackageIntegrity', address: Integrity::CONTRACT_ADDRESS,
                                    abi: contract_abi['abi'])

  puts "Private key is of #{Integrity::PRIVATE_KEY.length} bytes"
  key = Eth::Key.new(priv: Integrity::PRIVATE_KEY)

  collection.each do |name, value|
    next unless value['hashes'] && value['hashes']['sha2-256']

    throttle.call do
      do_request eth, contract, key, name, value
    end
  end
end
