# frozen_string_literal: true

require 'jekyll/generator'
require 'plist'

# This plugin generates data files in the result for every format of data provided in the _data folder
class JekyllLIMDRecoveryPlugin < Jekyll::Generator
  safe true
  priority :lowest

  # Sub page type for non file backed page (this is a bit of a misconception since the data file backs it
  # but since site.data is a hash and the original is lost, this becomes difficult - perhaps a fix in the
  # future these should be wrapped in Jekyll::DataSet or some such to retain more information, also solving
  # the folder problem)
  class GeneratedPage < Jekyll::Page
    # rubocop:disable Naming/MemoizedInstanceVariableName
    def read_yaml(*)
      @data ||= {}
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end

  def generate(site)
    result = {
      'env_vars' => site.site_data['nvram']['variables'].map { |var| var['name'] },
      'devices' => get_devices(site)
    }

    save_as_file(site, '.generated', 'irecovery.plist', result.to_plist)
  rescue StandardError => e
    warn "Error processing data file #{name}\n\n#{e}"
  end

  private

  def get_devices(site)
    site.site_data['cores']['chip_ids'].flat_map do |chip_id, chip_data|
      chip_data['boards'].map do |board_id, board_data|
        {
          'chip_id' => chip_id,
          'board_id' => board_id,
          'board_name' => board_data['board_name'],
          'product_id' => board_data['product_id'],
          'product_name' => board_data['product_name']
        }
      end
    end
  end

  def save_as_file(site, dir, name, content)
    file = GeneratedPage.new(site, __dir__, dir, name)
    file.content = content
    file.data['layout'] = nil

    site.pages << file
  end
end
