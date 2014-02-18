module Bender
  module Strategies
    class Base
      attr_accessor :game, :weight

      def initialize(game, weight)
        self.game = game
        self.weight = weight
      end

      def board
        game.board
      end

      def log(msg)
        game.log(msg)
      end
    end
  end
end
