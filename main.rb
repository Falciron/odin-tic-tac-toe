# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/game'

loop do
  current_game = ::Game.new
  current_game.establish_players
  current_game.play_game
  puts('Press Enter to continue or press Ctrl+C to quit.')
  gets
rescue ::Interrupt
  exit
end
