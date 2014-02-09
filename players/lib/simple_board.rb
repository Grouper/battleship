class SimpleBoard

  attr_reader :board

  # set up the following board
  #    0  1  2  3  4  5  6  7  8  9  0
  # [
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 0
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 1
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 2
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 3
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 4
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 5
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 6
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 7
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 8
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], # 9
  #   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  # 0
  #  ]
  #
  # @param max_x [Integer] number of rows
  # @param max_y [Integer] number of columns
  # @return [Array] a two dimensional array representing the board
  def initialize max_x = 10, max_y = 10
    @board = Array.new(max_y) { Array.new max_x, 0 }
  end

  def row n
    board[n]
  end

  def col n
    board.map { |r| r[n] }
  end

  def set_column n, value, range
    board[range].map { |r| r[n] = value }
  end

  def set_row n, value, range
    board[n].fill value, range
  end

end
