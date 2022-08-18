# frozen_string_literal: true

require 'spec_helper'

require 'img4'

TEST_IMG4P = Dir.glob(File.join(File.dirname(__FILE__), '../tmp/**/*.im4p')).first

if TEST_IMG4P
  describe Img4File do
    it 'should load the file' do
      Img4File.new(TEST_IMG4P)
    end

    it 'should have a payload the file' do
      file = Img4File.new(TEST_IMG4P)
      expect(file.payload?).to be true
      expect(file.payload).to_not be_nil
    end

    it 'should not have a manifest the file' do
      file = Img4File.new(TEST_IMG4P)
      expect(file.manifest?).to be false
      expect(file.manifest).to be_nil
    end

    it 'should not have a basename the file' do
      file = Img4File.new(TEST_IMG4P)
      file_basename = File.basename(TEST_IMG4P)

      puts "file_basename: #{file.basename}"
      expect(file.basename.length).to be(file_basename.length)
    end
  end
end
