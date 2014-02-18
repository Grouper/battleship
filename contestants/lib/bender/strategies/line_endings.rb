module Bender
  module Strategies
    class LineEndings < Base
      def score
        longest_remaining = game.ships.remaining.max
        game.lines(board.hits).each do |line|
          line.extensions.each do |xy|
            coord = board.at(*xy)
            coord.add(weight) if coord && coord.unknown?
          end
        end
      end
    end
  end
end
