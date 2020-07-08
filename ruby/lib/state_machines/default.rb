# frozen_string_literal: true

module StateMachines
  class Default
    def match_item?(_item)
      true
    end

    def next_state(item)
      sell_in = item.sell_in - 1
      quality = item.quality - (sell_in < 0 ? 2 : 1)
      { sell_in: sell_in, quality: quality }
    end
  end
end
