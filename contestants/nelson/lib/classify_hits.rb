# After a ship is sunk we must find its boundaries and mark all of
# it's cells as sunk. If we fail to do this, hits from already sunk
# ships may force us into a futile kill mode.
#
# For ship formations without any touching vessels, identifying a
# particular hit is easy. The problem becomes tricky for vessels
# touching another ships. Here there is a risk of miss-classifying
# cells.
#
# A simple backtracking based algorithm is used to pair individual
# kill events to ship boundaries.

class ClassifyHits
  def initialize player
    @board = player.board
  end

  def identify destroyed_ships
    # all hits were identified as ships
    return true if destroyed_ships.empty?
    destroyed_ships.each_with_index do |ship, ndx|
      placements(ship).each do |placement|
        set_all_cells_along_placement placement, :sunk
        remaining = destroyed_ships.dup
        remaining.delete_at(ndx)
        if identify(remaining)
          # identified all ships
          return true
        else
          set_all_cells_along_placement placement, :hit
        end
      end
    end
    # failed to identify a hit
    false
  end

  def placements ship
    x = ship[:hit_x]
    y = ship[:hit_y]
    length = ship[:length]
    possible = []

    # generate all possible ships sunk along the X axis
    lowest_starting_x = [0, x - length + 1].max
    lowest_starting_x.upto(x) do |start_x|
      end_x = start_x + length - 1
      next unless end_x < @board.grid_size
      if start_x.upto(end_x).all? { |xi| @board.hit?(xi, y)}
        possible.push start_x: start_x, end_x: end_x, start_y: y, end_y: y
      end
    end

    # generate all possible ships sunk along the Y axis
    lowest_starting_y = [0, y - length + 1].max
    lowest_starting_y.upto(y) do |start_y|
      end_y = start_y + length - 1
      next unless end_y < @board.grid_size
      if start_y.upto(end_y).all? { |yi| @board.hit?(x, yi)}
        possible.push start_x: x, end_x: x, start_y: start_y, end_y: end_y
      end
    end

    possible
  end


  def set_all_cells_along_placement placement, to
    placement[:start_x].upto(placement[:end_x]) do |x|
      placement[:start_y].upto(placement[:end_y]) do |y|
        @board.set_cell x, y, to
      end
    end
  end
end
