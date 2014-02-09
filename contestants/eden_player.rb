require 'set'
require 'matrix'

class EdenPlayer

  ACROSS = Vector[1, 0]
  DOWN = Vector[0, 1]

  def name
    # Uniquely identify your player
    "Eden"
  end

  def new_game
    # return an array of 5 arrays containing
    # [x,y, length, orientation]
    # e.g.
    # [
    #   [0, 0, 5, :down],
    #   [4, 4, 4, :across],
    #   [9, 3, 3, :down],
    #   [2, 2, 3, :across],
    #   [9, 7, 2, :down]
    # ]
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
    # state is the known state of opponents fleet
    # ships_remaining is an array of the remaining opponents ships

    return [x,y] # your next shot co-ordinates
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