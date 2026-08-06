# frozen_string_literal: true

module AppleData
  module DSL
    # A definition of a collection of objects, with a particular schema
    class CollectionDefinition
      attr_reader :name
      attr_accessor :mapper

      def initialize(name, mapper)
        @name = name
        @mapper = mapper
      end

      # Builds the collection into the given data file class
      def build!(klass)
        name = @name
        klass.instance_eval do
          define_method(name) do
            @mapped_collections ||= {}
            if @mapped_collections[name].nil?
              collection_definition = self.class.const_get(:COLLECTIONS)[name]

              value = collection(name.to_s)
              result = case value.data
                       when Hash
                         construct_hash(collection_definition, value)
                       when Array
                         construct_array(collection_definition, value)
                       else
                         value.data
                       end

              @mapped_collections[name] = result
            end

            @mapped_collections[name]
          end
        end
      end
    end
  end
end
