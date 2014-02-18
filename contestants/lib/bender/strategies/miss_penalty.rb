module Bender
  module Strategies
    class MissPenalty < Base
      def score
        board.misses.each do |miss|
          miss.adjacent.each{ |coord| coord.add weight }
        end
      end
    end
  end
end
