# typed: true
# frozen_string_literal: true

require 'jekyll/generator'
require 'plist'
require 'toml'
require 'active_support/all'

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

    def render_with_liquid?
      false
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end

  def deep_transform_hash(input_hash)
    return input_hash.map { |d| deep_transform_hash(d) } if input_hash.is_a?(Array)
    return transform_string(input_hash) unless input_hash.is_a?(Hash)

    input_hash.each_with_object({}) do |(k, v), result|
      # Transform the key
      new_key = transform_string(k)

      # If the value is a Hash, then recurse
      new_value = v.is_a?(Hash) || v.is_a?(Array) ? deep_transform_hash(v) : transform_string(v)

      result[new_key] = new_value
    end
  end

  def transform_string(input)
    if input.is_a?(String) || input.is_a?(Symbol)
      new_value = input.dup.force_encoding('ASCII-8BIT').encode('UTF-8', undef: :replace, replace: '')
      raise 'Somehow not UTF-8!' unless new_value.valid_encoding?

      new_value
    else
      input
    end
  end

  def formats_for_data(data)
    transformed_data = deep_transform_hash(data)
    {
      json: JSON.dump(transformed_data),
      yaml: transformed_data.to_yaml,
      plist: transformed_data&.to_plist
    }
  end

  def generate(site)
    site.site_data.each do |name, dataset|
      formats_for_data(dataset).each do |format, data|
        file = GeneratedPage.new(site, __dir__, '.data', "#{name}.#{format}")
        file.content = data
        file.data['layout'] = nil

        site.pages << file
      rescue StandardError => e
        warn "Error processing data file #{name} for dataset #{dataset} with #{format}\n\n#{e.inspect}"
      end
    end
  end
end
