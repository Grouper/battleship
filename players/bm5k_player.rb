require 'base'

%w[
  guesstimate
  hit_tracker
  move_tracker
  opening_moves
  random_placement
  state_tracker
].each { |s| require "strategy/#{ s }" }

class BM5kPlayer < Base

  prepend Guesstimate
  prepend OpeningMoves
  prepend HitTracker
  prepend MoveTracker
  prepend RandomPlacment
  prepend StateTracker

  def name
    'BM5k'
  end

  def new_game
    super
  end

  def take_turn state, ships_remaining
    track(@next_move || random_move).coords
  end

private

  def setup
    @opening_moves = [
      [3, 3], [3, 7], [5, 5], [7, 3], [7, 7]
    ].map { |pt| Point.new pt }
  end

end
