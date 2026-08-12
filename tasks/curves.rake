require 'openssl'
require 'merkle-hash-tree'
require 'deepsort'
require 'digest'

desc 'Build "One-True-Curve" Files'
task :curves do
  def deep_to_a(obj)
    case obj
    when Hash
      obj.map { |k, v| [k, deep_to_a(v)] }
    when Array
      obj.map { |e| deep_to_a(e) }
    else
      obj
    end
  end

  OUTPUT_FILE = File.join(__dir__, '../_data/curves/hashes.yml')
  output_data = {}

  Dir.glob(File.join(__dir__, '../ext/std-curves/**/*.json')).each do |file|
    next if File.basename(file) == 'schema.json'
    puts file
    curve_file = JSON.load_file file

    curve_group_name = curve_file['name'].gsub(/\//, '_')
    curve_dir = File.join(__dir__, '../_data/curves/', curve_group_name, 'asn')
    mkdir_p curve_dir

    curve_file['curves'].each do |curve|
      curve = curve.deep_symbolize_keys
      curve_name = curve[:name].gsub(/\//, '_')
      puts "Exporting #{file}:#{curve_name}"

      result_hash = curve.slice(:field, :params, :generator, :form, :order, :cofactor)
      result_hash.deep_transform_values! do |value|
        if value.is_a?(String) and value.start_with? '0x'
          Integer(value)
        end
      end

      output_thing = deep_to_a(result_hash.deep_sort)

      mht = MerkleHashTree.new(output_thing, Digest::SHA256)

      curve_hash = mht.head.unpack1('H*')
      output_data[curve_hash] ||= {}
      output_data[curve_hash]['names'] ||= []
      output_data[curve_hash]['names'] << curve_name
    end
  end

  File.write(OUTPUT_FILE, output_data.to_yaml)
end
