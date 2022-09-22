# frozen_string_literal: true

namespace :data do
  desc 'integrate key file'
  task keyfile: [:path] do |_task, args|
    raise 'invalid input file' unless File.exist? args[:path]

    input_keys = JSON.load_file args[:path]

    keybag = AppleData::GIDKeyBag[chip_id]

    AppleData.GIDKeyBag.save_all
  end
end
