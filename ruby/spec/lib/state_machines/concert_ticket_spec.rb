# frozen_string_literal: true

require 'state_machines/concert_ticket'
require 'item'

RSpec.describe StateMachines::ConcertTicket do
  let(:subject) { described_class.new }

  let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

  it 'matches name "Backstage passes to a TAFKAL80ETC concert"' do
    match = Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 0)
    no_match = Item.new('Concert ticket', 0, 0)

    expect(subject.match_item?(match)).to be true
    expect(subject.match_item?(no_match)).to be false
  end

  it 'increases quality' do
    item = Item.new(name, 100, 10)
    expect(subject.next_state(item)).to eq(quality: 11, sell_in: 99)
  end

  it 'increases quality by 2 when when there are 6..10 days til the concert' do
    next_state = ->(itm) { subject.next_state(itm) }
    expect(next_state[Item.new(name, 11, 10)]).to eq(quality: 11, sell_in: 10)
    expect(next_state[Item.new(name, 10, 10)]).to eq(quality: 12, sell_in: 9)
    expect(next_state[Item.new(name, 8, 10)]).to eq(quality: 12, sell_in: 7)
    expect(next_state[Item.new(name, 6, 10)]).to eq(quality: 12, sell_in: 5)

    expect(next_state[Item.new(name, 5, 10)][:quality]).not_to eq(12)
  end

  it 'increases its quality by 3 when when there are <=5 days til the concert' do
    next_state = ->(itm) { subject.next_state(itm) }
    expect(next_state[Item.new(name, 6, 10)]).to eq(quality: 12, sell_in: 5)
    expect(next_state[Item.new(name, 5, 10)]).to eq(quality: 13, sell_in: 4)
    expect(next_state[Item.new(name, 3, 10)]).to eq(quality: 13, sell_in: 2)
    expect(next_state[Item.new(name, 1, 10)]).to eq(quality: 13, sell_in: 0)

    expect(next_state[Item.new(name, 0, 10)][:quality]).not_to eq(13)
  end

  it 'drops the quality to 0 after the concert' do
    next_state = ->(itm) { subject.next_state(itm) }
    expect(next_state[Item.new(name, 1, 10)]).to eq(quality: 13, sell_in: 0)
    expect(next_state[Item.new(name, 0, 10)]).to eq(quality: 0, sell_in: -1)
    expect(next_state[Item.new(name, -1, 10)]).to eq(quality: 0, sell_in: -2)
  end
end
