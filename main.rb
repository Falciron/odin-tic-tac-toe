# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/game'

loop do
  ::Game.new
  puts('Press Enter to continue or press Ctrl+C to quit.')
  gets
rescue ::Interrupt
  exit
end
