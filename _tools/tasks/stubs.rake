# frozen_string_literal: true

namespace :stubs do
  desc 'create format stubs'
  task :formats do
    Dir.glob(File.join(BASE_PATH, '_data/*.yaml')) do |file|
      format_name = File.basename(file).delete_suffix '.yaml'

      document_name = File.join(BASE_PATH, "formats/#{format_name}.md")

      File.write(document_name, "# #{format_name}\n") unless File.exist? document_name
    end
  end
end
