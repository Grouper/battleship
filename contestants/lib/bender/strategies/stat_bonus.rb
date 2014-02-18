module Bender
  module Strategies
    class StatBonus < Base

      def score
        limit = game.options[:disable_stats]
        return if limit && game.moves.count >= limit
        Bender.game_stats.each_pair do |xy, score|
          board.at(*xy).add(score)
        end
      end

    end
  end
end
