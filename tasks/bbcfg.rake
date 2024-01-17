# frozen_string_literal: true

require_relative '../lib/common'
require_relative '../lib/baseband'

QUALCOMM_BBCFG_HEADER = 'a4L<L<L<QQQa8'

namespace :data do
  namespace :baseband do
    namespace :bbcfg do
      desc 'pull out blobs from a bbcfg'
      task :qc_blobs, [:file] do |_task, args|
        unless File.exist?(args[:file])
          puts "#{args[:file]} is not a regular file"
          exit(-1)
        end

        file = File.open(args[:file], 'rb')
        values = file.read(48).unpack(QUALCOMM_BBCFG_HEADER)

        if (values[0] != "\0GFC") || (values[1] != 3) ||
           (values[4] != 229_947_300_631_343_066) || (values[7] != 'BBCFGMBN')

          print("Invalid Header:\n\n#{values.inspect}")
          exit(-1)
        end

        parser = OpenSSL::ASN1.decode(file.read)
        print("Build Type: #{parser.entries[0].value}\n")
        print("Build Number: #{parser.entries[1].value}\n")
        print("Build Host: #{parser.entries[2].value}\n")
        print("Build User: #{parser.entries[3].value}\n")
        print("Build IP: #{parser.entries[4].value}\n")
        print("Build Commit Hash: #{parser.entries[5].value}\n")
        print("Build Date: #{parser.entries[6].value}\n")
        print("Build Branch: #{parser.entries[7].value}\n")

        # TODO: Loop over 8 and handle MCC/MNC or whatever those are....
        #

        base_dir = File.dirname(args[:file])
        extracted_dir = File.join(base_dir, "#{File.basename(args[:file])}_extracted")
        Dir.mkdir extracted_dir

        parser.entries[9].value.each do |blob|
          hash = blob.value[0].value
          content = blob.value[1].value

          if content[0..3] == 'MAVZ'
            print("Found MAVZ compressed file with hash #{hash}\n")
            output_file = File.join(extracted_dir, "#{hash}.bin")
            File.write(output_file, Zlib.inflate(content[8..]))
          else
            print("Found ASN1 coded patch file with hash #{hash}\n")
            output_file = File.join(extracted_dir, "#{hash}.stream")
            File.write(output_file, blob.value[1].value)
            print("Enumerating files in patch file:\n\n")
            print_files_in_patch(output_file)
          end
        end
      end
    end
  end
end
