# frozen_string_literal: true

require_relative '../gilded_rose'

#
# This is kinda functional test to cover general behaviour.
# This should be replaced with unit testing + some high
# level integration testing
describe GildedRose do
  def build_item(name, sell_in:, quality:)
    Item.new(name, sell_in, quality)
  end

  describe "#update_quality" do
    def subject(items)
      described_class.new(items).update_quality
    end

    pending 'never increases quality above 50'
    pending 'never decreases quality above 0'
    pending 'never changes the name'

    context 'for a plain item' do
      let(:name) { 'some item' }

      it 'lowers its sell_in and quality' do
        item1 = build_item(name, sell_in: 1, quality: 1)
        item2 = build_item(name, sell_in: 2, quality: 2)
        subject([item1, item2])

        expect(item1.sell_in).to be 0
        expect(item2.sell_in).to be 1
        expect(item1.quality).to be 0
        expect(item2.quality).to be 1
      end

      it 'cant degrade quality lower than zero (sell_in is fine)' do
        zero_sell_in = build_item(name, sell_in: 0, quality: 1)
        zero_quality = build_item(name, sell_in: 1, quality: 0)
        subject([zero_quality, zero_sell_in])

        expect(zero_sell_in.sell_in).to be(-1)
        expect(zero_quality.quality).to be 0
      end

      it 'degrades quality by 2 for out of date items (sell_in <= 0)' do
        sell_in_one = build_item(name, sell_in: 1, quality: 10)
        sell_in_zero = build_item(name, sell_in: 0, quality: 10)
        sell_in_minus_one = build_item(name, sell_in: -1, quality: 10)
        subject([sell_in_one, sell_in_zero, sell_in_minus_one])

        expect(sell_in_one.quality).to be 9
        expect(sell_in_zero.quality).to be 8
        expect(sell_in_minus_one.quality).to be 8
      end
    end

    context 'for "Sulfuras, Hand of Ragnaros"' do
      let(:name) { 'Sulfuras, Hand of Ragnaros' }

      it 'doesnt change anything' do
        item = build_item(name, sell_in: 1, quality: 1)
        subject([item])

        expect(item.sell_in).to be 1
        expect(item.quality).to be 1
      end
    end

    context 'for "Aged Brie"' do
      let(:name) { 'Aged Brie' }

      it 'increases quality instead of lowering it' do
        normal_item = build_item(name, sell_in: 5, quality: 10)
        out_of_date = build_item(name, sell_in: -1, quality: 10)
        zero_sell_in = build_item(name, sell_in: 0, quality: 10)
        max_quality = build_item(name, sell_in: 5, quality: 50)
        subject([normal_item, out_of_date, max_quality, zero_sell_in])

        expect(normal_item.quality).to be 11
        expect(out_of_date.quality).to be 12
        expect(max_quality.quality).to be 50
        expect(zero_sell_in.quality).to be 12

        expect(normal_item.sell_in).to be 4
        expect(out_of_date.sell_in).to be(-2)
        expect(max_quality.sell_in).to be 4
      end
    end

    context 'for "Backstage passes to TAFKAL80ETC concert"' do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

      it 'increases its quality like brie' do
        item = build_item(name, quality: 10, sell_in: 100)
        subject([item])

        expect(item.sell_in).to be 99
        expect(item.quality).to be 11
      end

      it 'increases its quality by 2 when when there are 6..10 days til the concert' do
        by_sell_in = {
          11 => build_item(name, quality: 10, sell_in: 11),
          10 => build_item(name, quality: 10, sell_in: 10),
          8 => build_item(name, quality: 10, sell_in: 8),
          6 => build_item(name, quality: 10, sell_in: 6),
          5 => build_item(name, quality: 10, sell_in: 5)
        }
        subject(by_sell_in.values)

        expect(by_sell_in[11].quality).to be 11
        expect(by_sell_in[10].quality).to be 12
        expect(by_sell_in[8].quality).to be 12
        expect(by_sell_in[6].quality).to be 12

        expect(by_sell_in[5].quality).not_to be 12
      end

      it 'increases its quality by 3 when when there are <=5 days til the concert' do
        by_sell_in = {
          6 => build_item(name, quality: 10, sell_in: 6),
          5 => build_item(name, quality: 10, sell_in: 5),
          3 => build_item(name, quality: 10, sell_in: 3),
          1 => build_item(name, quality: 10, sell_in: 1),
          0 => build_item(name, quality: 10, sell_in: 0)
        }
        subject(by_sell_in.values)

        expect(by_sell_in[6].quality).to be 12
        expect(by_sell_in[5].quality).to be 13
        expect(by_sell_in[3].quality).to be 13
        expect(by_sell_in[1].quality).to be 13

        expect(by_sell_in[0].quality).not_to be 13
      end

      it 'drops the quality to 0 after the concert' do
        zero = build_item(name, quality: 10, sell_in: 0)
        minus_one = build_item(name, quality: 10, sell_in: -1)
        subject([zero, minus_one])

        expect(zero.quality).to be 0
        expect(minus_one.quality).to be 0

        subject([zero, minus_one])
        expect(zero.quality).to be 0
        expect(minus_one.quality).to be 0
      end

      it 'doesnt set quality over 50' do
        item = build_item(name, quality: 50, sell_in: 100)
        subject([item])

        expect(item.sell_in).to be 99
        expect(item.quality).to be 50
      end
    end
  end
end
