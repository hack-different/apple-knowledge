# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AppleData::DataFile do
  it 'has data files' do
    expect(described_class.all).not_to be_empty
  end

  described_class.find_each do |klass|
    context klass.name do
      let(:instance) { klass.new }

      klass.const_get(:COLLECTIONS).each do |name, collection|
        context collection.name do
          it 'is consistent' do
            expect(instance.send(name)).not_to be_nil
          end
        end
      end
    end
  end
end
