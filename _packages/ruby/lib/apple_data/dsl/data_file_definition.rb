# frozen_string_literal: true

module AppleData
  module DSL
    # The DSL that is used when defining a data file
    class DataFileDefinition
      def initialize
        @collections = {}
      end

      def collection(name, mapper = nil, &)
        @collections[name] = AppleData::DSL::CollectionDefinition.new(name, mapper)
        if block_given? && @collections[name].mapper.nil?
          @collections[name].mapper = Class.new(AppleData::SchemaBase)
          @collections[name].mapper.class_eval(&)
        end
        @collections[name]
      end

      attr_writer :default_filename

      def build!
        klass = Class.new(DataFile)

        klass.const_set(:DEFAULT_FILENAME, @default_filename)
        klass.const_set(:COLLECTIONS, @collections)

        @collections.each_value do |collection_definition|
          collection_definition.build!(klass)
        end

        klass
      end
    end
  end
end
