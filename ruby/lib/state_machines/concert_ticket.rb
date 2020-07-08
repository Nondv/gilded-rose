module StateMachines
  class ConcertTicket
    def match_item?(item)
      item.name == 'Backstage passes to a TAFKAL80ETC concert'
    end

    def next_state(item)
      quality = if (6..10).include?(item.sell_in)
                  item.quality + 2
                elsif (1..5).include?(item.sell_in)
                  item.quality + 3
                elsif item.sell_in > 0
                  item.quality + 1
                else
                  0
                end
      sell_in = item.sell_in - 1

      { quality: quality, sell_in: sell_in }
    end
  end
end
