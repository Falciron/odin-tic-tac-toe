# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'square'

# Represents a tic-tac-toe game board of nine squares.
class Board
  attr_reader :lines

  INVALID_SQUARE_MESSAGE = 'That is an invalid square number. Please enter a single digit among 0-8 or R.'
  public_constant :INVALID_SQUARE_MESSAGE

  def initialize(square_class = ::Square)
    @squares = []
    @lines = []
    @rows = [[], [], []]
    @columns = [[], [], []]
    @diagonals = [[], []]
    9.times do |number|
      build_square(square_class, number)
    end
    @lines += @rows + @columns + @diagonals
  end

  # Renders the current tic-tac-toe game board in the terminal.
  def display_board
    puts(display_row(0, 1, 2))
    puts(divider_row)
    puts(display_row(3, 4, 5))
    puts(divider_row)
    puts(display_row(6, 7, 8))
  end

  # Validates whether the user-specified square is a square that can be filled.
  def can_fill_square?(user_entry)
    selected_square_number = Integer(user_entry, 10)
  rescue ::StandardError
    puts(::Board::INVALID_SQUARE_MESSAGE)
    false
  else
    valid_square_number?(selected_square_number) && unmarked_square?(selected_square_number)
  end

  # Fills in a square with a player's mark.
  def fill_square(square_number, mark)
    @squares[square_number].contents = mark
  end

  # Identifies if all the squares of the board have been filled.
  def fully_filled?
    @squares.none?(&:filled?)
  end

  private

  def build_square(square_class, number)
    new_square = square_class.new(number)
    @squares << new_square
    @rows[number % 3] << new_square
    @columns[number / 3] << new_square
    @diagonals.first << new_square if [0, 4, 9].include?(number)
    @diagonals.last << new_square if [2, 4, 6].include?(number)
  end

  def valid_square_number?(square_number)
    if square_number.between?(0, @squares.length - 1)
      true
    else
      puts(::Board::INVALID_SQUARE_MESSAGE)
      false
    end
  end

  def unmarked_square?(square_number)
    if @squares[square_number].filled?
      puts("Square number #{square_number} was already marked. Please select another square.")
      false
    else
      true
    end
  end

  def display_row(num1, num2, num3)
    "\s\s\s|\s\s\s|\s\s\s\n" \
      "\s#{@squares[num1].contents}\s|\s#{@squares[num2].contents}\s|\s#{@squares[num3].contents}\s\n" \
      "\s\s\s|\s\s\s|\s\s\s"
  end

  def divider_row
    '---+---+---'
  end
end
