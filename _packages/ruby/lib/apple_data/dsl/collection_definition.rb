# frozen_string_literal: true

module AppleData
  module DSL
    class CollectionDefinition
      attr_reader :name
      attr_accessor :mapper

      def initialize(name, mapper)
        @name = name
        @mapper = mapper
      end

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

                         result.to_h
                       when Array
                         value.data.map do |item|
                           if collection_definition.mapper
                             collection_definition.mapper.from_hash(item)
                           else
                             item
                           end
                         end
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
