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

      work_queue = Queue.new
      finished_queue = Queue.new

      collection.each do |page_id, entry|
        result_file_name = File.join(collection_file_path, "#{page_id}.page")
        next if !args[:force] && File.exist?(result_file_name)

        work_queue.push [page_id, entry, result_file_name]
      end

      threads = []
      16.times do
        threads << Thread.new do
          until work_queue.empty?
            begin
              page_id, entry, result_file_name = work_queue.pop(true)
              next unless page_id

              puts "Getting page #{page_id} (#{entry['title']})"
              page = TIPW.get_page_content entry['title']
              next unless page

              finished_queue.push(entry)

              File.write result_file_name, page.to_json
            rescue StandardError
              puts "Error getting page #{page_id} (#{entry['title']})"
            end
          end
        end
      end

      threads.each(&:join)

      until finished_queue.empty?
        entry = finished_queue.pop(true)
        entry['synced'] = true
      end

      collection.sort

      TIPW::SYNC_DATAFILE.save
    end
  end

  desc 'update keybags from TIPW pages in tmp/tipw/firmware_keys'
  task :keydb do
    input_key_files = File.join(TMP_DIR, 'tipw', 'tipw_firmware_keys', '*.page')
    keys = Dir.glob(input_key_files).map do |keyfile|
      TIPW::TIPWKeyPage.new(File.read(keyfile))
    rescue StandardError => e
      puts "Error parsing #{keyfile}\n\n#{e}"
      raise
    end

    keys = keys.compact.map(&:to_h).group_by { |key| key['device'] }
    keys = keys.map do |key, collection|
      [key, collection.group_by { |item| item['build'] }]
    end

    output_file = File.join(TMP_DIR, 'tipw', 'keydb.yaml')
    File.write(output_file, keys.to_h.to_yaml)
  end

  desc 'update firmware codenames from TIPW'
  task :codenames do
    TIPW::TIPWCodenames.new
  end

  desc 'update keybags from keydb'
  task :keys do
    keydb = YAML.load_file(File.join(TMP_DIR, 'tipw', 'keydb.yaml'))
    keydb.each do |product, builds|
      chip, board = find_chip_board(product)
      chip_keybag = AppleData::GIDKeyBag[chip]
      board_keybag = chip_keybag.get_board board
      builds.each do |build_id, build_list|
        build_list.each { |build| board_keybag.merge_keydb_build(build_id, build) }
      end
    end

    AppleData::GIDKeyBag.save_all
  end

  desc 'update IPSWs from downloaded TIPW pages'
  task :ipsws do
    data_file = DataFile.new 'ipsw'
    files_collection = data_file.collection :ipsw_files
    input_files = File.join(TMP_DIR, 'tipw', '**', '*.page')
    urls = Dir.glob(input_files).flat_map do |file|
      URI.extract(File.read(file))
    end

    ipsw_urls = urls.filter_map do |url|
      uri = URI.parse url
      uri if uri && %w[http https].include?(uri.scheme) && uri.path.ends_with?('.ipsw')

    rescue URI::InvalidURIError
      nil
    end

    uri_map = ipsw_urls.uniq.group_by do |uri|
      URI.decode_www_form_component File.basename(uri.path)
    end

    uri_map.each do |file, file_urls|
      single_file = files_collection.ensure_key file
      single_file['urls'] ||= []
      single_file['urls'] << { url: single_file.delete('url') } if single_file.key? 'url'

      file_urls.map(&:to_s).each do |single_url|
        single_file['urls'] << { 'url' => single_url } unless single_file['urls'].any? { |u| u['url'] == single_url }
      end
    end

    data_file.save
  end
end
