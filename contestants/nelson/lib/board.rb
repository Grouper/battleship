# Keep a local copy of the board. This looks much the same as the
# "state" parameter from "take_turn" method. Except that we markup
# sunk ships not just hits. Cells with :sunk have no effect on the
# static evaluation, whereas :hit cells trigger a localized search for
# a kill.
class Board
  def initialize
    @board = []
    @grid_size = LordNelsonPlayer::GRID_SIZE
    @grid_size.times do
      @board.push(Array.new(@grid_size, :unknown))
    end
  end

  attr_reader :grid_size

  def any_hits?
    each_starting_position do |x, y|
      return true if hit?(x, y)
    end
    false
  end

  def print name
    short = { unknown: '.', hit: 'h', sunk: 'S', miss: '#'}
    puts "--- #{name }"
    @board.each do |row|
      puts row.map { |t| short[t]}.join(' ')
    end
  end

  def hit_or_unknown? x, y
    unknown?(x, y) || hit?(x, y)
  end

  def unknown? x, y
    @board[y][x] == :unknown
  end

  def hit? x, y
    @board[y][x] == :hit
  end

  def on? x, y
    x >= 0 && y >= 0 && x < @grid_size && y < @grid_size
  end

  def set_cell x, y, value
    @board[y][x] = value
  end


  def each_starting_position_and_direction
    each_starting_position do |x, y|
      [[1, 0], [0, 1]].each do |dx, dy|
        xi = x + dx
        yi = y + dy
        if on?(xi, yi) && hit_or_unknown?(xi, yi)
          yield x, y, dx, dy
        end
      end
    end
  end


  def each_starting_position
    @grid_size.times do |x|
      @grid_size.times do |y|
        if hit_or_unknown? x, y
          yield x, y
        end
      end
    end
  end

end
