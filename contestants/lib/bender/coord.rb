module Bender
  class Coord
    attr_reader :game, :x, :y
    attr_accessor :status, :score

    def initialize(game, x, y, status)
      @game = game
      @x, @y = x, y
      self.status = status
      self.score  = 0
    end

    def board
      game.board
    end

    def adjacent
      [up, down, left, right].compact
    end

    def up
      at(x, y - 1)
    end

    def down
      at(x, y + 1)
    end

    def left
      at(x - 1, y)
    end

    def right
      at(x + 1, y)
    end

    def at(x, y)
      board.at(x, y)
    end

    def add(delta)
      self.score += delta
    end

    def miss?
      status == :miss
    end

    def to_s
      case status
      when :unknown
        score.to_s
      when :miss
        "M"
      else
        "X"
      end
    end
  end
end
