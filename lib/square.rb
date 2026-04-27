# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

# Represents a single square on a tic-tac-toe game board.
class Square
  attr_accessor :contents, :number

  def initialize(number)
    @number = number
    @contents = @number.to_s
  end

  # Determines whether a space is filled in by a character (true) or blank (false).
  def filled?
    @contents != number.to_s
  end
end
