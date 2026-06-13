# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative '../lib/game'

describe ::Game do
  before do
    allow($stdout).to(receive(:write))
  end

  describe '#establish_players' do
    subject(:unstarted_game) { described_class.new }

    let(:player_class)  { class_double(::Player)                      }
    let(:first_player)  { instance_double(::Player, name: 'Juan')     }
    let(:second_player) { instance_double(::Player, name: 'Georgia')  }

    before do
      allow($stdin).to(receive(:gets).and_return('Juan', 'Georgia'))
      allow(player_class).to(receive(:new).with('X', anything)).and_return(first_player)
      allow(player_class).to(receive(:new).with('O', anything)).and_return(second_player)
    end

    it 'sets the first player as the current player' do
      unstarted_game.establish_players(player_class)
      expect(unstarted_game.current_player).to(be(first_player))
    end
  end

  describe '#play_game' do
    subject(:configured_game) { described_class.new(game_board) }

    let(:game_board) { instance_double(::Board) }
    let(:empty_square)  { instance_double(::Square, contents: '0')                  }
    let(:x_square)      { instance_double(::Square, contents: 'X')                  }
    let(:o_square)      { instance_double(::Square, contents: 'O')                  }
    let(:game_player)   { instance_double(::Player, mark: '@', name: 'Umberto')     }

    before do
      allow(game_board).to(receive(:display_board))
      configured_game.instance_variable_set(:@current_player, game_player)
      configured_game.instance_variable_set(:@players, [game_player, game_player])
    end

    context 'when the game is cancelled on the first move' do
      before do
        allow($stdin).to(receive(:gets).and_return('R'))
      end

      it 'sends display_board to the board once' do
        configured_game.play_game
        expect(game_board).to(have_received(:display_board).once)
      end

      it 'stops the game loop with a false return value' do
        game_result = configured_game.play_game
        expect(game_result).to(be(false))
      end
    end

    context 'when the game is cancelled on the second move' do
      before do
        allow($stdin).to(receive(:gets).and_return('1', 'R'))
        allow(game_board).to(receive(:fill_square))
        current_board_lines = [[empty_square, x_square, empty_square]]
        allow(game_board).to(receive_messages(can_fill_square?: true, fully_filled?: false, lines: current_board_lines))
      end

      it 'sends display_board to the board twice' do
        configured_game.play_game
        expect(game_board).to(have_received(:display_board).twice)
      end

      it 'sends fill_square to the board once' do
        configured_game.play_game
        expect(game_board).to(have_received(:fill_square).once)
      end

      it 'stops the game loop with a false return value' do
        game_result = configured_game.play_game
        expect(game_result).to(be(false))
      end
    end

    context 'when the board contains a winning line' do
      before do
        allow($stdin).to(receive(:gets).and_return('2'))
        allow(game_board).to(receive(:fill_square))
        current_board_lines = [[x_square, x_square, x_square], [o_square, empty_square, o_square]]
        allow(game_board).to(receive_messages(can_fill_square?: true, fully_filled?: false, lines: current_board_lines))
      end

      it 'does not send display_board to the board a subsequent time' do
        configured_game.play_game
        expect(game_board).to(have_received(:display_board).once)
      end

      # This isn't the best way to detect an early return of the game, but it works.
      it 'stops the game loop with a true return value' do
        game_result = configured_game.play_game
        expect(game_result).to(be(true))
      end
    end

    context 'when all spaces have been filled on the board but there is no winning line' do
      before do
        allow($stdin).to(receive(:gets).and_return('2'))
        allow(game_board).to(receive(:fill_square))
        current_board_lines = [[x_square, o_square, x_square]]
        allow(game_board).to(receive_messages(can_fill_square?: true, fully_filled?: true, lines: current_board_lines))
      end

      it 'does not send display_board to the board a subsequent time' do
        configured_game.play_game
        expect(game_board).to(have_received(:display_board).once)
      end

      # This isn't the best way to detect an early return of the game, but it works.
      it 'stops the game loop with a true return value' do
        game_result = configured_game.play_game
        expect(game_result).to(be(true))
      end
    end
  end
end
