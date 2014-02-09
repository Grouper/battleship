require 'base'
require 'strategy/move_tracker'

class MoveTrackingPlayer < Base

  prepend MoveTracker

  def name
    'Move Tracker'
  end

  def new_game
    setup
    [
      [2, 2, 5, :across],
      [7, 0, 4, :down],
      [1, 6, 3, :down],
      [5, 7, 3, :across],
      [3, 3, 2, :down]
    ]
  end

  def take_turn state, ships_remaining
    track(random_move).coords
  end

private

  def setup
  end

end
