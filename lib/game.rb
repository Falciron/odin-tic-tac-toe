# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Represents a single game of tic-tac-toe.
class Game
  attr_reader :current_player, :players

  def initialize(board = ::Board.new)
    @board = board
  end

  # Initializes the pair of players with their names and marks.
  def establish_players(player_class = ::Player)
    @players = []
    %w[X O].each do |symbol|
      puts("What is player one's name?")
      @players << player_class.new(symbol, $stdin.gets.chomp)
    end
    @current_player = @players.first
    puts("#{@players.first.name} vs. #{@players.last.name}")
  end

  # Plays out the game, taking turns between each player, until the game is over.
  def play_game
    @board.display_board
    loop do
      user_entry = elicit_user_entry
      return false if user_entry == 'R'

      redo unless process_entry?(user_entry)
      return true if game_over?

      swap_current_player
      @board.display_board
    end
  end

  private

  def elicit_user_entry
    puts(
      "#{@current_player.name}, which space do you want to fill with an #{@current_player.mark}? " \
      '(Enter R to restart.)'
    )
    $stdin.gets.chomp
  end

  def process_entry?(user_entry)
    return false unless @board.can_fill_square?(user_entry)

    @board.fill_square(Integer(user_entry, 10), @current_player.mark)
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
