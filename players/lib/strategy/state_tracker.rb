module StateTracker

  def self.prepended base
    base.class_eval do
      attr_reader :sunk, :game_state, :remaining_ships
    end
  end

  def take_turn state, ships_remaining
    @game_state = state
    @next_move  = nil

    self.remaining_ships = ships_remaining
    super
  end

private

  def largest_ship
    remaining_ships.max
  end

  def setup
    @remaining_ships = []
    super
  end

  def remaining_ships= ships
    if remaining_ships.any?
      index = (0..remaining_ships.length).detect { |n| remaining_ships[n] != ships[n] }
      @sunk = index ? remaining_ships[index] : nil
    end

    @remaining_ships = ships
  end

  def rotated_state
    @game_state.each.with_index.inject([]) do |array, (row, index)|
      row.each_with_index do |column, j|
        array[j] ||= []
        array[j] << column
      end
      array
    end
  end

  def sunk?
    !!sunk
  end

end
