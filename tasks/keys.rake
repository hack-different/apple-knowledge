# frozen_string_literal: true

namespace :data do
  desc 'integrate key file'
  task keyfile: [:path] do |_task, args|
    raise 'invalid input file' unless File.exist? args[:path]

    input_keys = JSON.load_file args[:path]

    input_keys.each do |_entry|
      AppleData::Core.find_board
    end

    AppleData.GIDKeyBag.save_all
  end
end
