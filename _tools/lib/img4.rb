# frozen_string_literal: true

# Represents any given IMG4 file, uses openssl ASN1 to parse the file.
class Img4File
  VALID_EXTENSIONS = %w[img4 im4m im4p].freeze
  VALID_TYPES = %w[IM4P IMG4 IM4M].freeze

  def initialize(path)
    @path = path
    der = File.binread(path)
    @data = OpenSSL::ASN1.decode(der)

    case @data.first.value
    when 'IM4P'
      @type = @data[1].value
      @build = @data[2].value
      @payload = @data[3].value
    when 'IMG4', 'IM4M'
      raise 'Not implemented'
    else
      raise "Unknown IMG4 type #{@data.first.value}"
    end
  end

  def extract_payload
    basename = File.basename(@path)
    extension = File.extname(basename)
    output_filename = basename.chomp(extension)
    output_path = File.join(File.dirname(@path), output_filename)
    File.write(output_path, @payload)
  end

  def manifest?
    !@manifest.nil?
  end

  def payload?
    !@payload.nil?
  end
end
