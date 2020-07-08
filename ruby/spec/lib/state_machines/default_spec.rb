# frozen_string_literal: true

require 'state_machines/default'
require 'item'

RSpec.describe StateMachines::Default do
  let(:subject) { described_class.new }

  it 'matches any item' do
    expect(subject.match_item?(Item.new('blabla', 0, 0))).to be true
    expect(subject.match_item?(Item.new('234', 0, 0))).to be true
  end

  it 'decreases quality' do
    item = Item.new('123', 10, 10)
    expect(subject.next_state(item)).to eq(quality: 9, sell_in: 9)
  end

  it 'decreses quality by 2 when sell_in < 0' do
    one = Item.new('123', 1, 10)
    zero = Item.new('123', 0, 10)
    minus_one = Item.new('123', -1, 10)
    expect(subject.next_state(one)).to eq(quality: 9, sell_in: 0)
    expect(subject.next_state(zero)).to eq(quality: 8, sell_in: -1)
    expect(subject.next_state(minus_one)).to eq(quality: 8, sell_in: -2)
  end
end
