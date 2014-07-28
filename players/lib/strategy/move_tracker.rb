require 'point'

module MoveTracker

  def self.prepended base
    base.class_eval do
      attr_reader :moves
    end
  end

private

  def invalid_move? move
    !valid_move? move
  end

  def move_near point
    point.neighbors.select { |pt| valid_move? pt }.sample
  end

  def previous_move
    @moves.last
  end

  # fuck it, guess
  def random_move
    begin
      move = Point.new rand(10), rand(10)
    end until valid_move?(move)
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

  def valid_move? move
    return false if move.coords.any? { |n| n > 9 or 0 > n }
    return false if moves.include?(move)
    true
  end

end
