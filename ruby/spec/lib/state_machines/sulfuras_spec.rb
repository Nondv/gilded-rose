# frozen_string_literal: true

require 'state_machines/sulfuras'
require 'item'

RSpec.describe StateMachines::Sulfuras do
  let(:subject) { described_class.new }

  it 'matches name "Sulfuras, Hand of Ragnaros"' do
    match = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
    no_match = Item.new('Sulfuras, Foot of Ragnaros', 0, 0)
    expect(subject.match_item?(match)).to be true
    expect(subject.match_item?(no_match)).to be false
  end

  it 'has immutabe state (no degrading at all)' do
    item = Item.new('Sulfuras, Hand of Ragnaros', 10, 10)
    expect(subject.next_state(item)).to eq(quality: 10, sell_in: 10)
  end
end
