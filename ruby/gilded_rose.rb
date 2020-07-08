require_relative 'lib/item'
require_relative 'lib/state_machines/sulfuras'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    state_machines = [
      StateMachines::Sulfuras,
      StateMachines::AgedBrie
    ].map(&:new)

    @items.each do |item|
      sm = state_machines.find { |m| m.match_item?(item) }
      if sm
        next_state = sm.next_state(item)
        # TODO: This is not the best place for this kind of checks
        item.quality = [next_state[:quality], 50].min
        item.sell_in = next_state[:sell_in]

        next
      end

      if item.name != "Backstage passes to a TAFKAL80ETC concert"
        item.quality = item.quality - 1 if item.quality > 0
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end

      item.sell_in = item.sell_in - 1

      if item.sell_in < 0
        if item.name != "Backstage passes to a TAFKAL80ETC concert"
          if item.quality > 0
            item.quality = item.quality - 1
          end
        else
          item.quality = item.quality - item.quality
        end
      end
    end
  end
end
