require_relative 'lib/item'
require_relative 'lib/state_machine'
require_relative 'lib/state_machines/sulfuras'
require_relative 'lib/state_machines/aged_brie'
require_relative 'lib/state_machines/concert_ticket'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    engines = [
      StateMachines::Sulfuras,
      StateMachines::ConcertTicket,
      StateMachines::AgedBrie
    ].map(&:new)

    state_machine = StateMachine.new(engines)

    @items.each do |item|
      if state_machine.compatible?(item)
        next_state = state_machine.next_state(item)
        item.quality = next_state[:quality]
        item.sell_in = next_state[:sell_in]

        next
      end

      item.quality = item.quality - 1 if item.quality > 0
      item.sell_in = item.sell_in - 1
      item.quality = item.quality - 1 if item.sell_in < 0 && item.quality > 0
    end
  end
end
