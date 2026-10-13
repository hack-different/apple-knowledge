# frozen_string_literal: true

module AppleData
  # Base class for all data files
  class DataFile
    def self.define(&)
      dsl = AppleData::DSL::DataFileDefinition.new
      dsl.instance_eval(&)
      dsl.build!
    end

    def self.inherited(klass)
      super
      @data_files ||= []
      @data_files << klass
    end

    def self.all
      @data_files
    end

    attr_reader :data

    def initialize(*parts)
      @parts = parts
      @parts = [self.class.const_get(:DEFAULT_FILENAME)] if @parts.empty?
      load_file(*@parts)
    end

    def self.from_path(path)
      allocate.tap do |instance|
        instance.send(:load_path, path)
      end
    end

    def load_file(*parts)
      parts[-1] = "#{parts[-1]}.yaml" unless parts[-1].end_with? '.yaml'
      load_path(File.join(AppleData.data_location, File.join(*parts)))
    end

    def save!
      save_data data
    end

    def collection(name)
      @collections[name.to_s] ||= DataFileCollection.new(self, name)
    end

    def collections
      collection_list = @data['metadata']['collections'] ||= []
      collection_list.map { |name| collection(name) }
    end

    def sort!
      collections.each(&:sort!)
      return unless sort_paths

      sort_paths.each do |path|
        JsonPath.for(@data).gsub!(path) do |item|
          case item
          when Array
            item.sort
          when Hash
            item.sort_by { |key, _value| key }.to_h
          else
            item
          end
        end
      end
    end

    def auto_sort?
      value = metadata['auto_sort']
      value = true if value.nil?
      value
    end

    def metadata
      @data['metadata'] ||= {}
    end

    def sort_paths
      metadata['sort_paths']
    end

    private

    def load_path(path)
      loaded_data = File.exist?(path) ? YAML.load_file(path) : {}
      loaded_data = {} if loaded_data.nil?
      raise ArgumentError, "Expected a YAML mapping in #{path}" unless loaded_data.is_a?(Hash)

      @filename = path
      @data = loaded_data.with_indifferent_access
      @collections = {}
      @mapped_collections = {}
      ensure_metadata
      @data
    end

    def save_data(data)
      @collections.each do |name, collection|
        @data[name] = collection.data
      end

      File.write(@filename, data.to_hash.to_yaml)
    end

    def ensure_metadata
      @data['metadata'] ||= {}
      @data['metadata'].reverse_merge!({ 'description' => nil, 'credits' => [] })
      collections = @data['metadata']['collections'] ||= []
      collections.each do |name|
        collection name
      end
    end

    # A specific "collection" inside a data file.  Collections are enumerable groups of one type of item.
    # The schema of each item is the same within a collection.
    class DataFileCollection
      def initialize(data_file, collection_name)
        @data_file = data_file
        @collection_name = collection_name
        @collection_data = @data_file.data[@collection_name]
      end

      def data
        @collection_data
      end

      def sort!
        case @collection_data
        when Array
          @collection_data.sort!
        when Hash
          @collection_data = @collection_data.sort_by { |key, _value| key }.to_h
        end
      end
    end

    def construct_array(collection_definition, value)
      value.data.map do |item|
        if collection_definition.mapper
          collection_definition.mapper.from_hash(item)
        else
          item
        end
      end
    end

    def construct_hash(collection_definition, value)
      result = value.data.map do |key, item|
        instance = if item
                     if collection_definition.mapper
                       collection_definition.mapper.from_hash(item)
                     else
                       item
                     end
                   end
        instance.key = key if instance.respond_to? :key=
        [key, instance]
      end

      result.to_h.with_indifferent_access
    end
  end
end
