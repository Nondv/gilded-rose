# frozen_string_literal: true

##
# Combines multiple *engines* (see StateMachines module),
# chooses one for an item, and applies final changes to the output
#
# It might have been a good idea to create an abstract engine class like:
#
#     class StateMachines::Abstract
#       def skip_quality_check?
#         false
#       end
#
#       def next_state(item)
#         { quality: next_quality(item), sell_in: next_sell_in(item) }
#       end
#     end
#
# but I think separation is fine. This way we will be less tempted to
# introduce complex relationships (inheritance) between multiple engines so
# the code is more straight forward.
#
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
    result[:quality] = final_quality(eng, result[:quality])
    result
  end

  private

  attr_reader :engines

  def find_engine_for(item)
    engines.find { |e| e.match_item?(item) }
  end

  def final_quality(engine, quality)
    return quality if engine.respond_to?(:skip_quality_check?) && engine.skip_quality_check?
    return 50 if quality > 50
    return 0 if quality < 0

    quality
  end
end
