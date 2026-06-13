# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative '../lib/board'

describe ::Board do
  before do
    allow($stdout).to(receive(:write))
  end

  describe '#initialize' do
    subject(:fresh_game_board) { described_class.new(square_class) }

    let(:square_class)    { class_double(::Square)                    }
    let(:square_instance) { instance_double(::Square)                 }

    before do
      allow(square_class).to(receive(:new)).and_return(square_instance)
    end

    context 'when all squares are generated' do
      it 'contains nine squares' do
        actual_square_count = fresh_game_board.instance_variable_get(:@squares).size
        expect(actual_square_count).to(be(9))
      end
    end

    context 'when the winning lines are collected' do
      it 'contains eight lines' do
        actual_line_count = fresh_game_board.instance_variable_get(:@lines).size
        expect(actual_line_count).to(be(8))
      end
    end
  end

  describe '#can_fill_square?' do
    subject(:fillable_game_board) { described_class.new(square_class) }

    let(:square_class)    { class_double(::Square)                      }
    let(:filled_square)   { instance_double(::Square, filled?: true)    }
    let(:unfilled_square) { instance_double(::Square, filled?: false)   }

    before do
      allow(square_class).to(receive(:new)).and_return(unfilled_square)
      allow(square_class).to(receive(:new).with(0)).and_return(filled_square)
    end

    context 'when a non-numerical value is specified' do
      it 'returns false' do
        expect(fillable_game_board.can_fill_square?('@')).to(be(false))
      end
    end

    context 'when a numerical value beyond the square count is specified' do
      it 'returns false' do
        expect(fillable_game_board.can_fill_square?('16')).to(be(false))
      end
    end

    context 'when a filled square number is specified' do
      it 'returns false' do
        expect(fillable_game_board.can_fill_square?('0')).to(be(false))
      end
    end

    context 'when an unfilled square number is specified' do
      it 'returns false' do
        expect(fillable_game_board.can_fill_square?('1')).to(be(true))
      end
    end
  end

  describe '#fill_square' do
    subject(:unfilled_game_board) { described_class.new(square_class) }

    let(:square_class)    { class_double(::Square)                      }
    let(:unfilled_square) { instance_double(::Square, filled?: false)   }

    before do
      allow(square_class).to(receive(:new)).and_return(unfilled_square)
      allow(unfilled_square).to(receive(:contents=).with('X'))
    end

    it 'sends contents to Square' do
      unfilled_game_board.fill_square(1, 'X')
      expect(unfilled_square).to(have_received(:contents=).with('X'))
    end
  end

  describe '#fully_filled?' do
    subject(:full_game_board) { described_class.new(square_class) }

    let(:square_class)    { class_double(::Square)                      }
    let(:square_instance) { instance_double(::Square, filled?: false)   }

    before do
      allow(square_class).to(receive(:new)).and_return(square_instance)
    end

    it 'sends filled? to every Square' do
      full_game_board.fully_filled?
      expect(square_instance).to(have_received(:filled?).exactly(9).times)
    end
  end
end
