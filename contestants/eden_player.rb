require 'set'
require 'matrix'

class EdenPlayer
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
    my_board = new_board
    ships = [5, 4, 3, 3, 2]
    ship_pos = ships.map do |ship|
      lay_ship({ship_length: ship, board: my_board})
    end
  end

  def take_turn(state, ships_remaining)
    # state is the known state of opponents fleet
    # ships_remaining is an array of the remaining opponents ships

    return [x,y] # your next shot co-ordinates
  end

  def lay_my_ship(options = {})
    fail 'Board not found!' unless options[:board]
    options[:pos] ||= rand_pos(options[:board])
    orient_my_ship(options.merge limit: 1)
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
    translate_x, translate_y = [Vector[1, 0], Vector[0, 1]]
    # horizontally, until ship goes too left
    head = center.dup
    until head == center + Vector[-(options[:ship_length]), 0]
      body = (0...options[:ship_length]).map { |i| head + (i * translate_x) }
      body.delete center
      occupation_points << body if valid?(body, options[:board])
      head -= translate_x
    end
    # vertically, again until ship goes too far up
    head = center.dup
    until head == center + Vector[0, -(options[:ship_length])]
      body = (0...options[:ship_length]).map { |i| head + (i * translate_y) }
      body.delete center
      occupation_points << body if valid?(body, options[:board])
      head -= translate_y
    end
    EdenPlayer.prob_board occupation_points.flatten
  end

  def valid?(body, board)
    body.each do |coord|
      x, y = [coord[0], coord[1]]
      return false unless board[x][y] == :unknown
    end
    true
  end

  def rand_pos(board)
    ranked = Set.new
    board.each_with_index do |row, x|
      row.each_with_index do |e, y|
        rank = (e == :unknown ? w_mid(x) * w_mid(y) : 0)
        ranked << [x, y, rank]
      end
    end
    # here would do parity filtering

    ranked.max_by { |arr| arr.last }[0..1]
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
end