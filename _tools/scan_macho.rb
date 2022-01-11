# frozen_string_literal: true

require 'macho'

file = MachO.open ARGV[0]

binary = file.is_a?(MachO::FatFile) ? file.fat_archs[0] : file

binary.segments.each do |segment|
  puts "#{segment.type}: offset #{lc.offset}, size: #{lc.cmdsize}"
end
