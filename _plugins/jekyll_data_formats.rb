# frozen_string_literal: true

require 'jekyll/generator'
require 'plist'

# This plugin generates data files in the result for every format of data provided in the _data folder
class JekyllDataFormatsPlugin < Jekyll::Generator
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

  def formats_for_data(data)
    { json: JSON.dump(data), yaml: data.to_yaml, plist: data&.to_plist }
  end

  def generate(site)
    site.site_data.each do |name, dataset|
      formats_for_data(dataset).each do |format, data|
        file = GeneratedPage.new(site, __dir__, '.data', "#{name}.#{format}")
        file.content = data
        file.data['layout'] = nil

        site.pages << file
      end
    rescue StandardError => e
      warn "Error processing data file #{name}\n\n#{e}"
    end
  end
end
