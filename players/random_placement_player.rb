require 'base'

require 'strategy/move_tracker'
require 'strategy/random_placement'

class RandomPlacePlayer < Base

  prepend MoveTracker
  prepend RandomPlacment

  def name
    'Random Placement'
  end

  def new_game
    super
  end

  def take_turn state, ships_remaining
    track(random_move).coords
  end

private

  def setup
  end

end
