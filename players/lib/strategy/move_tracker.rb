require 'point'

module MoveTracker

  def self.prepended base
    base.class_eval do
      attr_reader :moves
    end
  end

private

  def move_near point
    point.neighbors.reject { |pt| pt.coords.any? { |n| n > 9 or 0 > n } or moves.include?(pt) }.sample
  end

  def previous_move
    @moves.last
  end

  # fuck it, guess
  def random_move
    begin
      move = Point.new rand(10), rand(10)
    end while moves.include?(move)
    move
  end

  def setup
    @moves = []
    super
  end

  def track move
    @moves.push move
    move
  end

end
