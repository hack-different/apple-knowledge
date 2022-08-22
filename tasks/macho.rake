#!/usr/bin/env ruby
# frozen_string_literal: true

# typed: ignore

require_relative '../lib/common'

FILESET_REGION = /__REGION\d+/

namespace :data do
  task :macho do |example|
    data_file = DataFile.new 'mach_o'
    file = MachO.open example

    binary = file.is_a?(MachO::FatFile) ? file.machos[0] : file

    data_file.data['segments'] ||= {}
    data_file.data['commands'] ||= {}

    binary.segments.each do |segment|
      next if (binary.filetype == :fileset) && FILESET_REGION.match?(segment.segname)

      seg = data_file.data['segments'][segment.segname] ||= { 'description' => nil }

      segment.sections.each do |section|
        seg[section.sectname] ||= { 'description' => nil }
      end
    end

    MachO::LoadCommands::LOAD_COMMANDS.each do |key, value|
      data_file.data['commands'][value.to_s] = { 'description' => nil, 'value' => key }
    end

    data_file.save
  end
end
