require 'eth'
require 'json'
require 'dotenv/load'
require 'rate_throttle_client'

class Response
  attr_accessor :status

  def initialize(status)
    @status = status
  end

  def self.rate_limit
    self.new 429
  end

  def self.success
    self.new 200
  end

  def headers
    { 'RateLimit-Remaining' => '0' }
  end
end

def do_request(eth, contract, key, name, value)
  eth.transact contract, 'storeHash', PackageType::IPSW, name, HashType::SHA2_256, value['hashes']['sha2-256'], gas_limit: 15000000, sender_key: key
  Response.success
rescue Eth::Client::RpcError
  Response.rate_limit
end

case ENV['RAKE_ENV']
when 'test'
  PRIVATE_KEY = [ENV['TEST_ETHEREUM_PRIVATE_KEY']].pack('H*')
  NODE_URL = ENV['TEST_ETHEREUM_RPC']
  CONTRACT_ADDRESS = ENV['TEST_INTEGRITY_CONTRACT']
else
  PRIVATE_KEY = [ENV['DEV_ETHEREUM_PRIVATE_KEY']].pack('H*')
  NODE_URL = ENV['DEV_ETHEREUM_RPC']
  CONTRACT_ADDRESS = ENV['DEV_INTEGRITY_CONTRACT']
end

module PackageType
  IPSW = 0
end

module HashType
  MD5 = 0
  SHA1 = 1
  SHA2_224 = 2
  SHA2_256 = 3
  SHA2_384 =4
  SHA2_512=5
  SHA3_224=6
  SHA3_256=7
  SHA3_384=8
  SHA3_512=9
  KECCAC_256=10
end

desc "Perform blockchain integrity upload"
task :integrity do
  data_file = AppleData::DataFile.new 'ipsw'
  collection = data_file.collection :ipsw_files
  throttle = RateThrottleClient::ExponentialIncreaseProportionalRemainingDecrease.new

  puts "Connection to Ethereum node: #{NODE_URL}"
  eth = Eth::Client.create(NODE_URL)
  abi_json = File.read(File.join(File.dirname(__FILE__), '../lib/ApplePackageIntegrity.json'))
  contract_abi = JSON.parse(abi_json)
  contract = Eth::Contract.from_abi(name: "ApplePackageIntegrity", address: CONTRACT_ADDRESS, abi: contract_abi['abi'])

  puts "Private key is of #{PRIVATE_KEY.length} bytes"
  key = Eth::Key.new(priv: PRIVATE_KEY)

  collection.each do |name, value|
    next unless value['hashes'] && value['hashes']['sha2-256']

    throttle.call do
      do_request eth, contract, key, name, value
    end
  end
end
