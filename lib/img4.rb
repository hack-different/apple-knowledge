# frozen_string_literal: true

# Represents any given IMG4 file, uses openssl ASN1 to parse the file.
class Img4File
  VALID_EXTENSIONS = %w[img4 im4m im4p].freeze
  VALID_TYPES = %w[IM4P IMG4 IM4M].freeze

  attr_reader :manifest, :payload

  def initialize(path)
    @path = path
    der = File.binread(path)
    @data = OpenSSL::ASN1.decode(der)
    @payload = nil
    @manifest = nil

    case @data.first.value
    when 'IM4P'
      @type = @data.value[1].value
      @build = @data.value[2].value
      @payload = @data.value[3].value
    when 'IMG4', 'IM4M'
      raise 'Not implemented'
    else
      raise "Unknown IMG4 type #{@data.first.value}"
    end
  end

  def basename
    basename = File.basename(@path)
    extension = File.extname(basename)
    "#{basename.chomp(extension)}.#{@type}"
  end

  def extract_payload
    output_path = File.join(File.dirname(@path), basename)
    File.write(output_path, @payload)
  end

  def manifest?
    !@manifest.nil?
  end

  def payload?
    !@payload.nil?
  end
end
