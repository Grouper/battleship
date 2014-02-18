module Bender
  module Strategies
    class HistoryBonus < Base
      def score
        remaining = game.past.remaining
        return if remaining.empty?
        total = game.past.total
        score = (total / remaining.count) * weight

        remaining.each do |ships|
          ships.each do |ship|
            ship.points.each do |xy|
              coord = board.at(*xy)
              coord.add(score) if coord && coord.unknown?
              # coord.add([weight, 5].min) if coord && coord.unknown?
              # coord.add 1
            end
          end
        end

      end

    end
  end
end
