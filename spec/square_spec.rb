# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative '../lib/square'

describe ::Square do
  subject(:fillable_square) { described_class.new(0) }

  it 'indicates when unfilled' do
    empty_square = fillable_square
    expect(empty_square).not_to(be_filled)
  end

  it 'indicates when filled' do
    fillable_square.contents = 'O'
    filled_square = fillable_square
    expect(filled_square).to(be_filled)
  end
end
