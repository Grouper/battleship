module Bender
  module Strategies
    class LongLines < Base

      def score
        by_length = game.lines(board.available).sort_by{ |line| 0 - line.length }
        return if by_length.empty?
        longest = by_length.first.length
        best = by_length.take_while{ |line| line.length == longest }
        best.each do |line|
          line.points.each do |x, y|
            coord = board.at(x, y)
            coord.add(weight)
          end
        end
      end

    end
  end
end
