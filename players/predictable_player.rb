require 'base'
require 'strategy/move_tracker'
require 'strategy/opening_moves'
require 'strategy/state_tracker'

class PredictablePlayer < Base

  prepend MoveTracker
  prepend OpeningMoves
  prepend StateTracker

  def name
    'Predictable'
  end

  def new_game
    setup
    [
      [1, 7, 5, :across],
      [6, 1, 4, :across],
      [2, 2, 3, :across],
      [7, 4, 3, :down],
      [4, 3, 2, :down]
    ]
  end

  def take_turn state, ships_remaining
    track(@next_move || random_move).coords
  end

private

  def setup
    @opening_moves = [
      [0, 0], [0, 5], [0, 9],
      [3, 3], [3, 7],
      [5, 0], [5, 5], [5, 9],
      [7, 3], [7, 7],
      [9, 0], [9, 9],
    ].map { |pt| Point.new pt }
  end

end
