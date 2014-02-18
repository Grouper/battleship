module Bender
  module Strategies
    class SunkBonus < Base
      def score
        board.sunk.each do |hit|
          hit.adjacent.each{ |coord| coord.add weight }
        end
      end
    end
  end
end
