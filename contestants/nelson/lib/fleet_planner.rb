# Basically just a randomized algorithm for positioning the fleet
# without overlapping vessels. It also makes use of a few additional
# constraints:
#
#    * Some ships should always be placed on the edge
#
#    * 66% of all ship cells should be on the edge
#
# Such formations should be more resilient to a probabilistic search.

class FleetPlanner
  def initialize player
    @player = player
  end

  def reset!
    @my_ships = []
    LordNelsonPlayer::GRID_SIZE.times do
      @my_ships.push(Array.new(LordNelsonPlayer::GRID_SIZE, :unknown))
    end
  end

  def place lengths
    @lengths = lengths
    @cell_count = lengths.inject(0) { |s, p| s + p}
    loop do
      reset!
      placements = lengths.map do |length|
        position_ship_of length
      end
      next unless ship_cells_on_the_edge(placements) >= @cell_count * 2 / 3
      next unless enough_ships_on_the_edge?(placements)
      return placements
    end
  end

  def position_ship_of length
    loop do
      free_coordinate = rand(LordNelsonPlayer::GRID_SIZE)
      constrained_coordinate = rand(LordNelsonPlayer::GRID_SIZE - length)
      placement =
        if rand(2).zero?
          [constrained_coordinate, free_coordinate, length, :across]
        else
          [free_coordinate, constrained_coordinate, length, :down]
        end
      pos = positions *placement
      if without_overlaps?(pos)
        place! pos
        return placement
      end
    end
  end

  def positions x, y, length, orientation
    dx, dy = (orientation == :down) ? [0, 1] : [1, 0]
    xi, yi = x, y
    pos = [[xi, yi]]
    (length-1).times do
      xi += dx
      yi += dy
      pos.push([xi, yi])
    end
    pos
  end

  def without_overlaps? pos
    pos.all? do |x, y|
      @my_ships[y][x] == :unknown
    end
  end

  def enough_ships_on_the_edge? placements
    far_edge = LordNelsonPlayer::GRID_SIZE - 1
    placements.count { |placement|
      positions(*placement).all? { |x, y|
        x.zero? || y.zero? || x == far_edge || y == far_edge
      }
    } > 1
  end

  def ship_cells_on_the_edge placements
    far_edge = LordNelsonPlayer::GRID_SIZE - 1
    placements.map { |placement|
      positions(*placement).count { |x, y|
        x.zero? || y.zero? || x == far_edge || y == far_edge
      }
    }.inject(0) { |s, p| s + p}
  end

  def place! pos
    pos.each do |x, y|
      @my_ships[y][x] = :hit
    end
  end


end
