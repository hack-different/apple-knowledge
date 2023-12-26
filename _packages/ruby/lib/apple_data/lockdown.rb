# typed: true
# frozen_string_literal: true

# Schema file for the `lockdownd.yaml` file
class LockdownData < DataFile
  def initialize
    super('lockdownd.yaml')
    @data ||= {}
    @data['clients'] ||= []
    @data['domains'] ||= []
  end

  def ensure_client(client)
    @data['clients'] << client unless @data['clients'].include? client
  end

  def ensure_domain_has_property(domain, property, _type = nil)
    domain_instance = get_domain domain

    return unless property

    domain_instance['properties'] << property unless domain_instance['properties'].include? property
  end

  def get_domain(domain)
    result = @data['domains'].find { |d| d['name'] == domain }
    unless result
      result = {}
      result['name'] = domain
      @data['domains'] << result
    end
    result['description'] ||= nil
    result['properties'] ||= []
    result
  end

  def data
    @data['clients'].sort!

    @data['domains'].each do |domain|
      domain['properties'].sort!
    end

    @data['domains'].sort_by! { |d| d['name'] }

    @data
  end
end
