# frozen_string_literal: true

require 'state_machine'

RSpec.describe StateMachine do
  def subject(engines)
    described_class.new(engines)
  end

  def engine_mock(matcher, next_state)
    Object
      .new
      .tap { |obj| obj.define_singleton_method(:match_item?, &matcher) }
      .tap { |obj| obj.define_singleton_method(:next_state, &next_state) }
  end

  it '#compatible? checks if an item matches any of the engines' do
    engines = [
      engine_mock(->(itm) { itm == 1 }, -> {}),
      engine_mock(->(itm) { itm == 2 }, -> {}),
      engine_mock(->(itm) { itm < 5 }, -> {})
    ]

    sm = subject(engines)
    expect(sm.compatible?(1)).to be true
    expect(sm.compatible?(2)).to be true
    expect(sm.compatible?(4)).to be true
    expect(sm.compatible?(7)).to be false
  end

  describe '#next_state' do
    it 'raises an error when not compatible'

    it 'calls #next_state on an appropriate engine' do
      engines = [
        engine_mock(->(itm) { itm == 1 }, ->(_) { { quality: 1, sell_in: 1 } }),
        engine_mock(->(itm) { itm == 2 }, ->(_) { { quality: 2, sell_in: 2 } }),
        engine_mock(->(itm) { itm == 2 }, ->(_) { { quality: 5, sell_in: 5 } })
      ]

      sm = subject(engines)
      expect(sm.next_state(1)).to eq(quality: 1, sell_in: 1)
      expect(sm.next_state(2)).to eq(quality: 2, sell_in: 2)
    end

    it 'sets quality to 50 if it is above that' do
      engine = engine_mock(->(_) { true }, ->(_) { { quality: 51, sell_in: 1 } })
      expect(subject([engine]).next_state(1)).to eq(quality: 50, sell_in: 1)
    end

    it 'sets quality to 0 when negative' do
      engine = engine_mock(->(_) { true }, ->(_) { { quality: -1, sell_in: 1 } })
      expect(subject([engine]).next_state(1)).to eq(quality: 0, sell_in: 1)
    end

    it 'checks if an engine responds to #skip_quality_check? and acts accordingly' do
      engine = engine_mock(->(_) { true }, ->(_) { { quality: 51, sell_in: 1 } })

      engine.define_singleton_method(:skip_quality_check?) { false }
      expect(subject([engine]).next_state(1)).to eq(quality: 50, sell_in: 1)

      engine.define_singleton_method(:skip_quality_check?) { true }
      expect(subject([engine]).next_state(1)).to eq(quality: 51, sell_in: 1)
    end
  end
end
