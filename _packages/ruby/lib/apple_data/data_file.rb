# frozen_string_literal: true

module AppleData
  # Base class for all data files
  class DataFile
    extend T::Sig
    attr_reader :data

    sig { params(parts: String).void }
    def initialize(*parts)
      @parts = parts
      @collections = {}
      T.unsafe(self).load_file(*parts)
      ensure_metadata
    end

    sig { params(path: String).returns(DataFile) }
    def self.from_file(path)
      instance = DataFile.allocate
      instance.instance_eval do
        @filename = path
        @collections = {}
        @data = YAML.load_file @filename if File.exist? @filename
        ensure_metadata
      end
      instance
    end

    sig { params(parts: String).returns(T::Hash[T.untyped, T.untyped]) }
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

    def save
      save!
    end

    def collection(name)
      @collections[name.to_s] ||= DataFileCollection.new(self, name)
    end

    private

    def save_data(data)
      File.write(@filename, data.to_yaml)
    end

    def sort!
      @collections.each do |c|
        c.sort!
      end
    end

    def ensure_metadata
      @data['metadata'] ||= {}
      @data['metadata'].reverse_merge!({ 'description' => nil, 'credits' => [] })
      (@data['metadata']['collections'] || []).each do |name|
        self.collection(name)
      end
    end
  end
end
