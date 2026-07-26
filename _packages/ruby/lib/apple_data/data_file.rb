# frozen_string_literal: true

module AppleData
  # Base class for all data files
  class DataFile
    attr_reader :data

    def initialize(*parts)
      @parts = parts
      @collections = {}
      load_file(*parts)
      ensure_metadata
    end

    def self.from_path(path)
      instance = DataFile.allocate
      instance.instance_eval do
        @filename = path
        @collections = {}
        @data = YAML.load_file @filename if File.exist? @filename
        ensure_metadata
      end
      instance
    end

    def load_file(*parts)
      parts[-1] = "#{parts[-1]}.yaml" unless T.must(parts[-1]).end_with? '.yaml'
      @filename = File.join(AppleData.data_location, T.unsafe(File).join(*parts))
      @data = {}
      @data = YAML.load_file @filename if File.exist? @filename
      @data
    end

    def save!
      save_data data
    end

    def collection(name)
      @collections[name.to_s] ||= DataFileCollection.new(self, name)
    end

    def sort!
      @collections.each_value(&:sort)
    end

    def auto_sort?
      @data['metadata']['auto_sort']
    end

    private

    def save_data(data)
      File.write(@filename, data.to_yaml)
    end

    def ensure_metadata
      @data['metadata'] ||= {}
      @data['metadata'].reverse_merge!({ 'description' => nil, 'credits' => [] })
      collections = @data['metadata']['collections'] ||= []
      collections.each do |name|
        self.collection name
      end
    end

    class DataFileCollection
      def initialize(data_file, collection_name)
        @data_file = data_file
        @collection_name = collection_name
        @collection_data = @data_file.@collections[@collection_name]
      end
    end
  end
end