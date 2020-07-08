# frozen_string_literal: true

module StateMachines
  # This *kinda* duplicates Default engine.
  # The difference is that it degrades twice as fast.
  # But we don't want to rely on inheritance so no code is shared
  class Conjured
    def match_item?(item)
      item.name == 'Conjured'
    end

    def next_state(item)
      sell_in = item.sell_in - 1
      quality = item.quality - (sell_in < 0 ? 4 : 2)
      { sell_in: sell_in, quality: quality }
    end
  end
end
