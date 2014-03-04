require_relative "lib/board"
require_relative "lib/fleet_planner"
require_relative "lib/classify_hits"
require_relative "lib/probability_board"

class LordNelsonPlayer
  def name
    "Lord Nelson"
  end

  GRID_SIZE = 10
  SHIP_LENGTHS = [5, 4, 3, 3, 2]

  def initialize
    @remaining = SHIP_LENGTHS.dup
    @last_move = nil
    @unidentified_sunk_ships = []
    @board = Board.new
  end

  attr_reader :board
  attr_reader :remaining

  def kill_mode?
    @mode == :kill
  end

  def set_mode mode
    @mode = mode
  end


  def new_game
    planner = FleetPlanner.new(self)
    planner.place(SHIP_LENGTHS)
  end

  def take_turn(state, ships_remaining)
    update_board state, ships_remaining
    probabilities = ProbabilityBoard.new(self)
    @last_move = probabilities.best_move
  end

  def update_board state, ships_remaining
    if @last_move
      x, y = @last_move
      @board.set_cell x, y, state[y][x]
    end

    # we just sunk a ship
    if ships_remaining.length != @remaining.length
      intel = ClassifyHits.new(self)
      if intel.identify(find_unidentified_sunk_ships(ships_remaining))
        @unidentified_sunk_ships = []
      end
      @remaining = ships_remaining.dup
    end

    set_mode(@board.any_hits? ? :kill : :search)
  end

  def find_unidentified_sunk_ships ships_remaining
    @remaining.each_with_index do |local, local_i|
      if ships_remaining[local_i].nil? || ships_remaining[local_i] != local
        x, y = @last_move
        @unidentified_sunk_ships << { length: local, hit_x: x, hit_y: y}
        break
      end
    end
    @unidentified_sunk_ships
  end


end
