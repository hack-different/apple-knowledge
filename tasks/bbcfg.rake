# frozen_string_literal: true

require_relative '../lib/common'
require_relative '../lib/baseband'

QUALCOMM_BBCFG_HEADER = 'a4L<L<L<QQQa8'

namespace :data do
  namespace :baseband do
    namespace :bbcfg do
      desc 'pull out blobs from a bbcfg'
      task :qc_blobs, [:file] do |_task, args|
        exit(-1) unless File.exist?(args[:file])

        File.open(args[:file], 'rb') do |file|
          values = file.read(48).unpack(QUALCOMM_BBCFG_HEADER)

          if (values[0] != "\0GFC") || (values[1] != 3) ||
             (values[4] != 229_947_300_631_343_066) || (values[7] != 'BBCFGMBN')

            exit(-1)
          end

          parser = OpenSSL::ASN1.decode(file.read)

          # TODO: Loop over 8 and handle MCC/MNC or whatever those are....
          #

          base_dir = File.dirname(args[:file])
          extracted_dir = File.join(base_dir, "#{File.basename(args[:file])}_extracted")
          Dir.mkdir extracted_dir

          parser.entries[9].value.each do |blob|
            hash = blob.value[0].value
            content = blob.value[1].value

            if content[0..3] == 'MAVZ'

              output_file = File.join(extracted_dir, "#{hash}.bin")
              File.write(output_file, Zlib.inflate(content[8..]))
            else

              output_file = File.join(extracted_dir, "#{hash}.stream")
              File.write(output_file, blob.value[1].value)

              print_files_in_patch(output_file)
            end
          end
        end
      end
    end
  end
end
