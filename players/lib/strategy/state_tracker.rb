module StateTracker

  def self.prepended base
    base.class_eval do
      attr_reader :game_state, :remaining_ships
    end
  end

  def take_turn state, ships_remaining
    @game_state      = state
    @next_move       = nil
    @remaining_ships = ships_remaining
    super
  end

end
