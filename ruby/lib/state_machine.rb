# frozen_string_literal: true

#
# Combines multiple *engines* (see StateMachines module),
# chooses one for an item, and applies final changes to the output
class StateMachine
  def initialize(engines)
    @engines = engines
  end

  def compatible?(item)
    !!find_engine_for(item)
  end

  def next_state(item)
    eng = find_engine_for(item)
    raise unless eng

    result = eng.next_state(item)
    result[:quality] = 50 if result[:quality] > 50
    result[:quality] = 0 if result[:quality] < 0

    result
  end

  private

  attr_reader :engines

  def find_engine_for(item)
    engines.find { |e| e.match_item?(item) }
  end
end
