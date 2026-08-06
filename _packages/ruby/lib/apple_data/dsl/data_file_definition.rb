# frozen_string_literal: true

module AppleData
  module DSL
    # The DSL that is used when defining a data file
    class DataFileDefinition
      def initialize
        @collections = {}
        @methods = {}
      end

      def collection(collection_name, mapper = nil, &)
        data_collection_name = self.class.name
        @collections[collection_name] = AppleData::DSL::CollectionDefinition.new(collection_name, mapper)
        if block_given? && @collections[collection_name].mapper.nil?
          @collections[collection_name].mapper = Class.new(AppleData::SchemaBase)
          @collections[collection_name].mapper.const_set(:DATA_COLLECTION_NAME, data_collection_name)
          @collections[collection_name].mapper.const_set(:COLLECTION_NAME, collection_name)
          @collections[collection_name].mapper.instance_eval do
            def name
              "#{self.class.const_get(:DATA_COLLECTION_NAME)}:#{self.class.const_get(:COLLECTION_NAME)}"
            end
          end
          @collections[collection_name].mapper.class_eval(&)
        end
        @collections[collection_name]
      end

      def define_method(name, &proc)
        @methods[name] = proc
      end

      attr_writer :default_filename

      def build!
        klass = Class.new(DataFile)

        klass.const_set(:DEFAULT_FILENAME, @default_filename)
        klass.const_set(:COLLECTIONS, @collections)

        @collections.each_value do |collection_definition|
          collection_definition.build!(klass)
        end

        @methods.each do |name, proc|
          klass.define_method(name, &proc)
        end

        klass
      end
    end
  end
end
