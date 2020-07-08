# frozen_string_literal: true

require 'state_machines/conjured'
require 'item'

RSpec.describe StateMachines::Conjured do
  let(:subject) { described_class.new }
  let(:name) { 'Conjured' }

  it 'matches "Conjured" name' do
    expect(subject.match_item?(Item.new('Conjured', 0, 0))).to be true
    expect(subject.match_item?(Item.new('Conjured item', 0, 0))).to be false
  end

  it 'decreases quality by 2' do
    item = Item.new('123', 10, 10)
    expect(subject.next_state(item)).to eq(quality: 8, sell_in: 9)
  end

  it 'decreses quality by 4 when sell_in < 0' do
    one = Item.new('123', 1, 10)
    zero = Item.new('123', 0, 10)
    minus_one = Item.new('123', -1, 10)
    expect(subject.next_state(one)).to eq(quality: 8, sell_in: 0)
    expect(subject.next_state(zero)).to eq(quality: 6, sell_in: -1)
    expect(subject.next_state(minus_one)).to eq(quality: 6, sell_in: -2)
  end
end
