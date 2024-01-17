# frozen_string_literal: true

require_relative 'common'

# Parser for the output of `kmutil dumpstate`
class KextStatDumpState
  # Represents a kernel extension (kext/dext) loaded from disk
  class KextBundle
    # rubocop:disable Layout/LineLength
    LINE_REGEX = /\s*(\S+) v(\S+) \((no uuid|[0-9A-F\-]+)\) in (codeless|executable) (kext|dext) bundle (\S+) at (.+) signed (.*) \(([a-f0-9]+)\) (entitlements: \[(.*)\] )?flags \[(.*)\]/
    # rubocop:enable Layout/LineLength

    attr_accessor :id, :version, :hash, :uuid, :codeless, :type, :path, :bundle, :flags, :signer, :entitlements

    def initialize(match)
      @id = match[1]
      @version = match[2]
      @uuid = match[3]
      @codeless = match[4] == 'codeless'
      @type = match[5]
      @bundle = match[6]
      @path = match[7]
      @signer = match[8]
      @hash = match[9]
      @entitlements = match[11] if match[11]
      @flags = match.to_a.last.split(',')
    end
  end

  # Represents a kernel extension, or psudo-extension loaded from kernel or a .kc
  class KextEntry
    # rubocop:disable Layout/LineLength
    LINE_REGEX = /\s*(\S+) v(\S+) \((no uuid|[0-9A-F\-]+)\) in loaded (system|boot|auxiliary) (kext|kernel) collection signed (<(.*)>|(\S+))( \((.*)\))? flags \[(.*)\]/
    # rubocop:enable Layout/LineLength

    attr_accessor :id, :version, :uuid, :codeless, :collection_type, :signer, :flags, :collection

    def initialize(match)
      @id = match[1]
      @version = match[2]
      @uuid = match[3] == 'no uuid' ? nil : match[3]
      @codeless = match[4] == 'codeless'
      @collection = match[5]
      @collection_type = match[6]
      @signer = match[7] unless match[7] == 'none'
      @flags = match.to_a.last.split(',')
    end
  end

  attr_accessor :entries

  def initialize(output)
    @entries = []
    state = [nil]
    output.lines.each do |line|
      state.shift if line.start_with?(/\s/) && state.first == :multiple
      case line
      when /== Extensions by identifier:/
        state = [:by_identifier]
      when /multiple candidates found for ([a-zA-Z.]+):/
        state.unshift :multiple
      when /== Invalid extensions:/
        state = [:invalid]
      when /== Loaded auxiliary extensions:/
        state = [:auxiliary]
      when KextBundle::LINE_REGEX
        @entries << KextBundle.new(Regexp.last_match)
      when KextEntry::LINE_REGEX
        @entries << KextEntry.new(Regexp.last_match)
      else
        print("Unparsed line: #{line}")
      end
    end
  end
end
