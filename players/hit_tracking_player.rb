require 'base'
require 'strategy/hit_tracker'
require 'strategy/move_tracker'
require 'strategy/state_tracker'

class HitTrackingPlayer < Base

  prepend HitTracker
  prepend MoveTracker
  prepend StateTracker

  def name
    'Hit Tracker'
  end

  def new_game
    setup
    [
      [9, 2, 5, :down],
      [2, 5, 4, :down],
      [4, 2, 3, :down],
      [5, 6, 3, :across],
      [1, 1, 2, :across]
    ]
  end

  def take_turn state, ships_remaining
    track(@next_move || random_move).coords
  end

private

  def setup
  end

end
