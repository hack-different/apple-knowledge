# typed: true
# frozen_string_literal: true

# Factory Device Restore
class FDRData < DataFile
  def initialize
    super('fdr.yaml')

    @data ||= {}

    @data['properties'] = []
  end

  def ensure_property(prop)
    prop_instance = @data['properties'].find { |p| p['name'] == prop }
    unless prop_instance
      prop_instance = {}
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
