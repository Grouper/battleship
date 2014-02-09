require 'set'
require 'matrix'

class EdenPlayer

  # needed to switch between shooting strategies
  attr_accessor :hunting
  # needed to track when a ship was sunk
  attr_accessor :opponents_ships
  attr_accessor :last_hit
  attr_accessor :last_board

  ACROSS = Vector[1, 0]
  DOWN = Vector[0, 1]

  def initialize
    @hunting = true
    @opponents_ships = [5, 4, 3, 3, 2]
    @last_board = EdenPlayer.new_board
  end

  # Uniquely identifies President Eden
  def name
    "Eden"
  end

  # returns where to lay Eden's ships at the start of a new game
  def new_game
    my_board = EdenPlayer.new_board
    ships = [5, 4, 3, 3, 2]
    probs = positional_probabilities my_board
    ship_pos = ships.map do |ship|
      laid = nil
      until laid
        pos = draw_next_min probs
        laid = lay_ship({ship_length: ship, board: my_board, pos: pos})
      end
      laid
    end
  end

  def take_turn(state, ships_remaining)
    update_state!(ships_remaining)
    if @hunting
      next_hunting_point(state)
    else
      next_target_point(state, ships_remaining, @last_hit)
    end
  end

  # in charge of switching between hunting and targetting modes by detecting
  # both new hits and new sunk ships. Mutates state.
  def update_state!(new_board, ships_remaining)
    if (hit = detect_hit(@last_board, new_board))
      @hunting = false
      @last_hit = hit
    end
    unless ships_remaining.sort == @opponents_ships.sort
      @hunting, @opponents_ships = [true, ships_remaining]
    end
    @last_board = new_board
  end

  # detects differences between boards
  def detect_hit(old_state, new_state)
    new_state.each_with_index do |row, y|
      next if row == old_state[y]
      row.each_with_index do |sym, x|
        next if sym == old_state[y][x]
        return [x, y] if sym == :hit
      end
    end
    nil
  end

  def lay_ship(options = {})
    dirs = [{down: DOWN}, {across: ACROSS}]
    until dirs.empty?
      rand_dir = dirs.delete dirs.sample
      body = body_from_head options[:pos], options[:ship_length], rand_dir.values.first
      if valid? body, options[:board]
        # modifies the board
        fill_game_board!(options[:board], :taken, body)
        return [*options[:pos], options[:ship_length], rand_dir.keys.first]
      end
    end
  end

  def next_target_point(state, ships, pos)
    sum_probs = aggregate_targets(state, ships, pos)
    max = sum_probs.to_a.flatten.max
    sum_probs.index(max).reverse
  end

  def aggregate_targets(state, ships, pos)
    sum_probs = ships.inject(EdenPlayer.prob_board) do |a,e|
      a + probable_enemy_occupations(ship_length: e, pos: pos, board: state)
    end
    sum_probs
  end

  # This method is used for evaluating where a ship could be on the board for
  # firing, it returns a matrix representing filled space for each position
  # for each allowed position of a ship, it creates a matrix representation
  # of the board with each point filled with the number of orientations that
  # occupy that point on the board
  def probable_enemy_occupations(options = {})
    fail 'Position not given!' unless options[:pos]
    # starting with the rightmost...leftmost. Then bottommost...topmost
    occupation_points = []
    center = Vector[*options[:pos]]
    # horizontally, until ship goes too left
    head = center.dup
    until head == center + Vector[-(options[:ship_length]), 0]
      body = body_from_head(head, options[:ship_length], ACROSS)
      body.delete center
      occupation_points << body if valid?(body, options[:board])
      head -= ACROSS
    end
    # vertically, again until ship goes too far up
    head = center.dup
    until head == center + Vector[0, -(options[:ship_length])]
      body = body_from_head(head, options[:ship_length], DOWN)
      body.delete center
      occupation_points << body if valid?(body, options[:board])
      head -= DOWN
    end
    EdenPlayer.prob_board occupation_points.flatten
  end

  def body_from_head(head, length, direction)
    head = Vector[*head] unless head.is_a? Vector
    (0...length).map { |i| head + (i * direction) }
  end

  def valid?(body, board)
    body.each do |coord|
      x, y = [coord[0], coord[1]]
      return false unless x >= 0 && x <= 9 && y >= 0 && y <= 9
      return false unless board[x][y] == :unknown
    end
    true
  end

  def next_hunting_point(board)
    probs = positional_probabilities(board)
    # here would do parity filtering
    probs.max_by { |h| h[:rank] }[:pos]
  end

  # specifically for narrowing down points for laying ships
  def draw_next_min(prob_set)
    min = prob_set.min_by { |h| h[:rank] }
    prob_set.delete min
    min[:pos]
  end

  # given a board, create a set containing points and ranks of likeliness
  def positional_probabilities(board)
    ranked = Set.new
    board.each_with_index do |row, y|
      row.each_with_index do |e, x|
        rank = (e == :unknown ? w_mid(x) * w_mid(y) : 0)
        ranked << {pos: Vector[x, y], rank: rank}
      end
    end
    ranked
  end

  # weight middle of the battleship board higher
  # return a higher output number when the input number is closer to 5
  def w_mid(num)
    ((num - 5).abs - 5).abs
  end

  def self.new_board
    Array.new(10) { Array.new(10) { :unknown } }
  end

  def self.prob_board(coords_to_fill = [])
    board = Array.new(10) { Array.new(10) { 0 } }
    coords_to_fill.each do |coord|
      x, y = [coord[0], coord[1]]
      board[x][y] += 1
    end
    Matrix[*board]
  end

  def fill_game_board!(board, symbol, arr_coords)
    arr_coords.each do |coord|
      x, y = [coord[0], coord[1]]
      board[x][y] = symbol
    end
    board
  end
end