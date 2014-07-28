require 'simple_board'

module RandomPlacment

  def self.prepended base
    base.class_eval do
      attr_reader :own_board
    end
  end

  def new_game
    super
    Base::SHIPS.map { |s| place_ship s }
  end

private

  def place_across column, row, size
    raise "Illegal Placement (#{column + size}) at #{ [column, row, size].inspect }" if column + size > 10

    range = column...(column + size)

    return false unless own_board.row(row)[range].all? { |n| n == 0 }

    own_board.set_row row, size, range
    [column, row, size, :across]
  end

  def place_down column, row, size
    raise "Illegal Placement (#{row + size}) at [#{column}, #{row}, #{size}]" if row + size > 10
    range = row...(row + size)
    return false unless own_board.col(column)[range].all? { |n| n == 0 }

    own_board.set_column column, size, range
    [column, row, size, :down]
  end

  def place_ship size
    placed = false

    until placed
      a, b = [rand(10), rand(10 - size + 1)]

      placed = if rand(2) % 2 == 1
        place_down   a, b, size
      else
        place_across b, a, size
      end
    end
    placed
  end

  def setup
    @own_board = SimpleBoard.new
    super
  end

end
