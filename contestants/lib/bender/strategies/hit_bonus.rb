module Bender
  module Strategies
    class HitBonus < Base
      def score
        board.hits.each do |hit|
          hit.adjacent.each{ |coord| coord.add weight }
        end
      end
    end
  end
end
