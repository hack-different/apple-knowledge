# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

CLASS_NAME_REGEX = /o\s([A-Za-z0-9\s,\-_]+)(@[a-fA-F0-9]+)?\s+<class ([a-zA-Z0-9:]+),/
BEGIN_PROPERTIES_REGEX = /\{$/
PROPERTY_LINE_REGEX = /"([A-Za-z0-9 ]+)" = ([^\n]+)$/
END_PROPERTIES_REGEX = /\}$/

namespace :data do
  task :ioreg do |example_dir|
    data_file = DataFile.new 'ioreg'
    data_file.data['classes'] ||= []

    unique_classes = data_file.data['classes'].select { |entry| IORegClass.load_one(entry) }

    Dir.glob(File.join(example_dir, '*.txt')).each do |file|
      puts "Scanning File: #{file}"
      instance = nil
      File.readlines(file).each do |line|
        match = line.match CLASS_NAME_REGEX

        next unless match

        tree = match[3].split(/:/).reverse

        puts "#{match[1]}: #{tree.inspect}"

        name = match[1].strip

        instance = IORegClass.for_name(tree.first)
        instance.parents = tree[1..]
        instance.known_names ||= []
        instance.known_names << name unless instance.known_names.include? name
      rescue StandardError => e
        puts "Error: #{e}\nError Line: #{line}"
      end
    end

    unique_classes.uniq!

    data_file.data['classes'] = IORegClass.values.map(&:to_h)

    data_file.save
  end
end
