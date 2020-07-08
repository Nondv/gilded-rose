# frozen_string_literal: true

require 'state_machines/aged_brie'
require 'item'

RSpec.describe StateMachines::AgedBrie do
  let(:subject) { described_class.new }

  let(:name) { 'Aged Brie' }

  it 'matches name "Aged Brie"' do
    match = Item.new('Aged Brie', 0, 0)
    no_match = Item.new('Brie', 0, 0)

    expect(subject.match_item?(match)).to be true
    expect(subject.match_item?(no_match)).to be false
  end

  it 'increases quality' do
    item = Item.new(name, 10, 10)
    expect(subject.next_state(item)).to eq(quality: 11, sell_in: 9)
  end

  it 'increases quality by 2 when sell_in < 0' do
    one = Item.new(name, 1, 10)
    zero = Item.new(name, 0, 10)
    minus_one = Item.new(name, -1, 10)
    expect(subject.next_state(one)).to eq(quality: 11, sell_in: 0)
    expect(subject.next_state(zero)).to eq(quality: 12, sell_in: -1)
    expect(subject.next_state(minus_one)).to eq(quality: 12, sell_in: -2)
  end
end
