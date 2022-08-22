# frozen_string_literal: true

GET_VALUE_REGEX = /handle_get_value: (\w+) attempting to get \[([^\]]+)\]:\[([^\]]+)\]/
SET_VALUE_REGEX = /handle_set_value: (\w+) attempting to set \[([^\]]+)\]:\[([^\]]+)\] to [([^\]]+)] of type (\d+)/

DIRTIED_DOMAIN_REGEX = /data_ark_set_block_invoke: dirtied by changing ([a-zA-Z0-9.]+)-([A-Za-z0-9]+)/

namespace :data do
  namespace :lockdownd do
    desc 'scan lockdownd log for data update'
    task :example do |example_file|
      data_file = LockdownData.new

      File.open(example_file, 'r') do |file|
        file.each_line do |line|
          case line
          when DIRTIED_DOMAIN_REGEX
            data_file.ensure_domain_has_property Regexp.last_match(1), Regexp.last_match(2)
            puts "Dirtied #{Regexp.last_match(1)} key #{Regexp.last_match(2)}"
          when GET_VALUE_REGEX
            data_file.ensure_client Regexp.last_match(1)
            key = Regexp.last_match(3) == '(null)' ? nil : Regexp.last_match(3)
            data_file.ensure_domain_has_property Regexp.last_match(2), key
            puts "Get #{Regexp.last_match(2)} key #{key}"
          when SET_VALUE_REGEX
            data_file.ensure_client Regexp.last_match(1)
            key = Regexp.last_match(3) == '(null)' ? nil : Regexp.last_match(3)
            data_file.ensure_domain_has_property Regexp.last_match(2), key, Regexp.last_match(5)
            puts "Set #{Regexp.last_match(2)} key #{key}"
          end
        end
      end

      data_file.save!
    end
  end
end
