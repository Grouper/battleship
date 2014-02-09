module HitTracker

  def self.prepended base
    base.class_eval do
      attr_reader :hits
    end
  end

  def take_turn *args
    track_hits
    @next_move ||= seek_and_destroy
    super
  end

private

  # try to move near a hit
  #
  # this checks for moves near the most recent hit, if none are found it
  # removes the hit from the list & checks the next one
  #
  # how do we avoid wasting turns on empty spaces near hits?
  def seek_and_destroy
    while hits.any?
      if move = move_near(hits.last)
        return move
      else
        @hits.pop
      end
    end
  end

  def previous_move_was_hit?
    @game_state[previous_move.y][previous_move.x] == :hit
  end

  def track_hits
    @hits.push previous_move if previous_move && previous_move_was_hit?
  end

  def setup
    @hits = []
    super
  end

end
