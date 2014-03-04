# Evaluate the best possible coordinate for of the next bomb. This is
# done via by positioning all remaining enemy ships in all possible
# ways over the board. Then the probability of a hit is computed by
# counting how many times a particular bomb had hit a possible ship
# placement.
#
# If there are hits on the board already, then all adjacent cells get
# a probability boost that is exponentially proportional to the number
# of hits in the possible placement. Cells containing sunk ships are
# ignored. The exponential rule forces a directional kills as ships
# are either horizontal or vertical.

class ProbabilityBoard

  def initialize player
    @player = player
    @board = player.board
    @score_board = []
    LordNelsonPlayer::GRID_SIZE.times do
      @score_board.push(Array.new(LordNelsonPlayer::GRID_SIZE, 0))
    end
    compute
  end

  # Positions each remaining enemy ship using every possibly
  # placement. The score_board is a matrix where each cell contains
  # the damage score for a hit placed at (x, y).
  def compute
    @board.each_starting_position_and_direction do |x, y, dx, dy|
      @player.remaining.each do |length|
        placement = generate_placement x, y, dx, dy, length
        if placement.length == length
          score_placement placement
        end
      end
    end
  end

  def generate_placement x, y, dx, dy, length
    xi, yi = x, y
    placement = [[xi, yi]]
    (length-1).times do
      xi += dx
      yi += dy
      break unless @board.on?(xi, yi)
      if @board.hit_or_unknown?(xi, yi)
        placement.push([xi, yi])
      end
    end
    placement
  end

  def count_hits_in placement
    return 0 unless @player.kill_mode?
    hits = placement.select { |x, y| @board.hit?(x, y) }.size
  end

  def score_placement placement
    hits = count_hits_in placement
    placement.each do |x, y|
      if @board.unknown?(x, y)
        @score_board[y][x] += 100**hits
      end
    end
  end

  # Computes the coordinate with the highest score. If multiple peaks
  # are found, a random one is selected.
  def best_move
    max_score = 0
    moves = []
    @board.each_starting_position do |x, y|
      next unless @board.unknown?(x, y)
      if @score_board[y][x] > max_score
        max_score = @score_board[y][x]
        moves = [[x, y]]
      elsif @score_board[y][x] == max_score
        moves.push([x, y])
      end
    end
    moves.sample
  end

end
