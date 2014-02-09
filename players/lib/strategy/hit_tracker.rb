module HitTracker

  def self.prepended base
    base.class_eval do
      attr_reader :hits
    end
  end

  def take_turn *args
    track_hits

    if sunk?
      slope = @hits[-1].slope @hits[-2]                       # calculate slope of last two hits
      ship  = sunk.times.map { |n| @hits.last.send slope, n } # use slope * length of ship to calculate ship coords
      @hits = @hits - ship                                    # remove ship coords from hits
    end

    @next_move ||= seek_and_destroy
    super
  end

private

  # try to move near a hit
  #
  # this checks for moves near the most recent hit, if none are found it
  # removes the hit from the list & checks the next one
  def seek_and_destroy
    if hits.length >= 2
      # calculate slope of last two hits & look in that direction
      move = @hits[-2].send @hits[-1].slope(@hits[-2])
      return move if valid_move?(move)

      # try the opposite direction
      move = @hits[-1].send @hits[-2].slope(@hits[-1])
      return move if valid_move?(move)
    end

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
