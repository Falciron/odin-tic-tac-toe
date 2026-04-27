# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'player'

# Represents a single game of tic-tac-toe.
class Game
  attr_reader :current_player, :players

  def initialize
    @players = []
    @board = ::Board.new

    establish_players
    @current_player = @players.first

    play_game
  end

  private

  # Initializes the pair of players with their names and marks.
  def establish_players
    puts("What is player one's name?")
    @players << ::Player.new('X', gets.chomp)
    puts("What is player two's name?")
    @players << ::Player.new('O', gets.chomp)
    puts("#{@players.first.name} vs. #{@players.last.name}")
  end

  def play_game
    @board.display_board
    loop do
      user_entry = elicit_user_entry
      break if user_entry == 'R'

      redo unless process_entry?(user_entry)
      break if game_over?

      swap_current_player
      @board.display_board
    end
  end

  def elicit_user_entry
    puts(
      "#{@current_player.name}, which space do you want to fill with an #{@current_player.mark}? " \
      '(Enter R to restart.)'
    )
    gets.chomp
  end

  def process_entry?(user_entry)
    valid_square = @board.can_fill_square?(user_entry)
    return false unless valid_square

    @board.fill_square(user_entry, @current_player.mark)
    true
  end

  def swap_current_player
    @current_player = @current_player == @players.first ? @players.last : @players.first
  end

  def game_over?
    if game_won?
      puts("Congratulations, #{@current_player.name}, you won!")
      true
    elsif @board.fully_filled?
      puts("#{@current_player.name} filled the last space, but nobody won.")
      true
    else
      false
    end
  end

  def game_won?
    @board.lines.any? { |line| line.first.contents == line[1].contents && line.first.contents == line.last.contents }
  end
end
