# frozen_string_literal: true

module StateMachines
  # Doesn't change over time
  # NOTE: could be named "LegendaryItem"
  class Sulfuras
    def match_item?(item)
      item.name == 'Sulfuras, Hand of Ragnaros'
    end

    def next_state(item)
      { sell_in: item.sell_in, quality: item.quality }
    end
  end
end
