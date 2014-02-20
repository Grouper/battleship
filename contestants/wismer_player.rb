require 'matrix'
class WismerPlayer
  attr_reader :ships, :enemy_ships
  attr_accessor :score_grid
  def name
    "Wismer Player"
  end

  def new_game

    # Game starts here
    # Ships are placed in a particular way

    ships = [[5, 1, 5, :down], [1, 5, 4, :across], [2, 2, 3, :across], [3, 7, 3, :down], [7, 8, 2, :down]]

    @enemy_ships = [5, 4, 3, 3, 2]

    # after placement of the ships the battle map is converted into a score board
    # with each block in the grid given a certain score depending on it's proximity to the
    # edge of the board

    @score_grid = Matrix.build(10).to_a.map { |elem| assign_base_score(elem.reverse) }
    @directions = [:up, :down, :left, :right]
    @shots      = []
    ships
  end


  def assign_base_score(elem)
    if elem[0] == 0 || elem[1] == 0 || elem[0] == 9 || elem[1] == 9
      elem = [1] + elem
    elsif elem[0] == 1 || elem[1] == 1 || elem[0] == 8 || elem[1] == 8
      elem = [2] + elem
    elsif elem[0] == 2 || elem[1] == 2 || elem[0] == 7 || elem[1] == 7
      elem = [3] + elem
    else
      elem = [5] + elem
    end
  end

  def take_turn(state, ships_remaining)

    # checks the status of the board

    @state       = state
    @ships       = ships_remaining
    @enemy_ships = enemy_ships - ships_remaining if ship_sunk?

    @shots << best_shot

    # the best shot that gets loaded also gets inserted into @shots for record keeping for the following if/else statement

    # if last was a hit and no ships were sunk, then the modifier for the adjacent tiles is doubled.
    # if last was a miss and no ships were sunk, the modifier is left unchanged

    if last_shot_hit? && !ship_sunk?
      adjust_table(:mod)
    else
      adjust_table
    end

    # the best shot is then returned to the game.

    best_shot
  end

  def ship_sunk?
    @enemy_ships.size > @ships.size
  end

  def ship_size
    @enemy_ships.max || 1
  end

  def last_shot_hit?
    x, y = @shots.last
    @state[x][y] == :hit
  end

  def score_list
    @score_grid.sort_by { |num| num[0] }
  end

  def adjust_table(modifier = nil)
    mod = modifier.nil? ? 1 : 5

    @state.each_with_index do |e, y|
      e.each_with_index do |m, x|
        if m == :hit
          @directions.each { |dir| adjacent_box(y, x, ship_size * mod, dir, :hit) }
        elsif m == :miss
          @directions.each { |dir| adjacent_box(y, x, 2 * mod, dir, :miss) }
        end
      end
    end
  end

  def adjacent_box(y, x, n, direction, type)
    # by way of the "cardinal" direction, the adjacent tile gets selected.

    case direction
    when :up then y += 1
    when :down then y -= 1
    when :left  then x += 1
    when :right then x -= 1
    end

    # add conditional to prevent going over the board
    tile       = @score_grid.find { |e| e[1..2] == [x, y] }
    tile_index = @score_grid.index(tile)
    if n > 0 && [y, x].all? { |num| (0..9).cover?(num) }
      # using 'n' as the number of steps to repeat, the new tile that's selected will increase in value or decrease depending on the
      # proximity to the original shot. Each additional tile will decrease the modifier.
      # e.g. A tile that is 1 tile above a hit will receive a bonus of +2 to the tile's value.

      # The reverse is true for a miss.
      tile       = @score_grid.find { |e| e[1..2] == [x, y] }
      tile_index = @score_grid.index(tile)

      if type == :hit && !@score_grid[tile_index].nil?
        @score_grid[tile_index][0] += n
      elsif type == :miss && !@score_grid[tile_index].nil?
        @score_grid[tile_index][0] -= n
      end

      adjacent_box(y, x, n - 1, direction, type)
      # though this works, I think this would require some alterations in order to sharpen it's accuracy
    end
  end

  def best_shot

    # since the board_map method will keep track of the hits and misses and their respective locations,
    # best_shot will remove these shots from the possible targets so as to prevent shooting at the same spot over and over again.

    score_list.delete_if { |num| board_map.include?(num[1..2]) }.last[1..2]
  end

  def board_map
    tiles = []
    @state.each_with_index do |box, y|
      box.each_with_index do |b, x|
        tiles << [x, y] if b == :hit || b == :miss
      end
    end
    return tiles
  end
end
