# frozen_string_literal: true

module AppleData
  # Represents a GID grouping of encrypted and decrypted keybags
  class Keybag < DataFile
    @keybags = {}

    attr_reader :keybags

    def self.save_all
      @keybags.each_value(&:save)
    end

    def self.[](chip_id)
      chip_id = chip_id.to_i
      return @keybags[chip_id] if @keybags.key? chip_id

      instance = allocate
      instance.send(:initialize, chip_id)
      @keybags[chip_id] = instance
    end

    def initialize(chip_id)
      super('keybags', chip_id.to_s)
    end

    def get_board(board_id)
      board_id = board_id.to_i
      boards = collection(:keybag_boards)
      BoardKeyBag.new self, board_id, boards.ensure_key(board_id, description: false)
    end

    # A keybag of builds for a particular build
    class BoardKeyBag
      def initialize(gid_keybag, board_id, board)
        @keybag = gid_keybag
        @board_id = board_id
        @board = board
      end

      def merge_keydb_build(build_id, build)
        return unless build['keybags']

        @board[build_id] ||= {} # : build
        @board[build_id]['components'] ||= {}
        @board[build_id]['components'].reverse_merge! build['keybags']
      end
    end
  end
end
