require 'base'

%w[
  guesstimate
  hit_tracker
  move_tracker
  random_placement
  state_tracker
].each { |s| require "strategy/#{ s }" }

class SmartPlayer < Base

  prepend Guesstimate
  prepend HitTracker
  prepend MoveTracker
  prepend RandomPlacment
  prepend StateTracker

  def name
    'Smart Player'
  end

  def new_game
    super
  end

  def take_turn state, ships_remaining
    track(@next_move || random_move).coords
  end

private

  def setup
  end

end
