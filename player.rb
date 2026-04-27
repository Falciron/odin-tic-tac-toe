# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

# Represents one of two players in a game of tic-tac-toe.
class Player
  attr_reader :mark, :name

  def initialize(mark, name)
    @mark = mark
    @name = name
  end
end
