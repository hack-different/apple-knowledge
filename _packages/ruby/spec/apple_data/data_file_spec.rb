require 'spec_helper'

RSpec.describe AppleData::DataFile do
  it 'should have data files' do
    expect(AppleData::DataFile.all).to_not be_empty
  end

  AppleData::DataFile.all.each do |klass|
    puts klass
    context klass.name do
      let(:instance) { klass.new }

      klass.const_get(:COLLECTIONS).each do |name, collection|
        context collection.name do
          it "should be consistent" do
            expect(instance.send(name)).to_not be_nil
          end
        end
      end
    end
  end
end