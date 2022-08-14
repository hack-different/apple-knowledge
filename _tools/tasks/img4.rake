# frozen_string_literal: true

require_relative '../lib/img4'

namespace :img4 do
  desc 'Extract any img4 files in the tmp directory'
  task :extract do
    Dir.glob(File.join(TMP_DIR, '**/*.im4p')).each do |path|
      file = Img4File.new(path)
      file.extract_payload
    end
  end
end
