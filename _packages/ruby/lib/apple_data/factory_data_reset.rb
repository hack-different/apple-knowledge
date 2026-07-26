# typed: true
# frozen_string_literal: true

module AppleData
  # Factory Device Restore
  class FactoryDataReset < AppleData::DataFile
    def initialize
      super('fdr.yaml')

      @data ||= {} # : data

      @data['properties'] = [] # : [property]
    end

    def ensure_property(prop)
      prop_instance = @data['properties'].find { |p| p['name'] == prop }
      unless prop_instance
        prop_instance = {} # : property
        prop_instance['name'] = prop
        prop_instance['description'] = nil
        @data['properties'] << prop_instance
      end
      prop_instance
    end

    def data
      @data['properties'].sort_by! { |prop| prop['name'] }

      @data
    end
  end
end
