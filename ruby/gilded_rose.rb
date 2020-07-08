require_relative 'lib/item'
require_relative 'lib/state_machine'
require_relative 'lib/state_machines/sulfuras'
require_relative 'lib/state_machines/aged_brie'
require_relative 'lib/state_machines/concert_ticket'
require_relative 'lib/state_machines/default'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    engines = [
      StateMachines::Sulfuras,
      StateMachines::ConcertTicket,
      StateMachines::AgedBrie,
      StateMachines::Default
    ].map(&:new)

    state_machine = StateMachine.new(engines)

    @items.each do |item|
      next unless state_machine.compatible?(item)

      next_state = state_machine.next_state(item)
      item.quality = next_state[:quality]
      item.sell_in = next_state[:sell_in]
    end
  end
end
