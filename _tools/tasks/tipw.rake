# frozen_string_literal: true

require_relative '../lib/tipw'

namespace :tipw do
  desc 'update category listings'
  task :categories do
    TIPW::SYNC_DATAFILE.collection(:tipw_categories).each do |key, value|
      collection = TIPW::SYNC_DATAFILE.collection key

      TIPW.get_pages_in_category(value).each do |page_entry|
        sync_entry = collection.ensure_key page_entry['pageid'].to_i, description: false
        sync_entry['title'] = page_entry['title']
        sync_entry['complete'] ||= false
        sync_entry['synced'] ||= false
      end
    end

    TIPW::SYNC_DATAFILE.save
  end

  desc 'update raw data pages in tmp'
  task :pages, [:force] do |_task, args|
    TIPW::SYNC_DATAFILE.collection(:tipw_categories).each do |key, _value|
      collection_file_path = File.join(TMP_DIR, 'tipw', key)
      FileUtils.mkdir_p collection_file_path

      collection = TIPW::SYNC_DATAFILE.collection key

      collection.each do |page_id, entry|
        result_file_name = File.join(collection_file_path, "#{page_id}.page")
        next if !args[:force] && File.exist?(result_file_name)

        puts "Downloading page: '#{entry['title']}'"
        File.write(result_file_name, TIPW.get_page_content(entry['title']))
        entry['downloaded'] = true
      end

      TIPW::SYNC_DATAFILE.save
    end
  end
end
