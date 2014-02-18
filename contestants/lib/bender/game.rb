require "securerandom"

module Bender
  class Game
    attr_reader :board, :moves, :past, :id, :options
    attr_accessor :strategies

    def initialize(strategies, options = {})
      @options = options
      @id = SecureRandom.hex(4)
      @moves = []
      # @logger = Logger.new("debug.log")
      initial_ships = [5, 4, 3, 3, 2]
      @board = Board.new(self)
      @finder = LineFinder.new(self)
      @sinker = ShipSinker.new(self, initial_ships)
      @placer = ShipPlacer.new(self, initial_ships)
      @past   = PastGames.new(self, @options)
      init_strategies strategies
    end

    def update(state, ships_remaining)
      board.update(state)
      past.whittle board.hits, board.misses
      @sinker.update(ships_remaining)
    end

    def run_scores
      @strategies.values.each(&:score)
      if options[:log_board]
        log "Lines:\n#{lines(board.hits).inspect}\nBoard:\n#{board.inspect}"
      end
    end

    def best_move
      by_score = board.available.sort_by{ |c| c.score * -1 }
      top = by_score.first.score
      by_score.take_while{ |c| c.score >= top }.sample
    end

    def init_strategies(strategies)
      @strategies = {}.tap do |s|
        strategies.each do |name, weight|
          s[name] = Strategies.const_get(name).new(self, weight)
        end
      end
    end

    def log(msg)
      @logger.info msg if @logger
    end

    def lines(coords)
      @finder.lines(coords)
    end

    def ships
      @sinker
    end

    def placements
      @placements ||= @placer.place.map(&:to_a)
    end

    def move
      coord = best_move
      @moves << coord.to_a
      # log "Next move: #{coord.inspect}"
      coord.to_a
    end

    def last
      board.at(*moves.last) if moves.any?
    end
  end
end
