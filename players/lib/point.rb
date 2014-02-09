class Point

  attr_reader :x, :y

  # Creates a new point with the given coordinates.
  #
  # @param x [Integer] the x coordinate
  # @param y [Integer] the y coordinate
  # @raise RuntimeError unless two arguments are passed
  def initialize *args
    raise "Must provide x and y coordinates!" unless [*args].flatten.length == 2
    @x, @y = [*args].flatten
  end

  # Compare points' coordinates.
  #
  # @param other_point [Point] the point to compare
  # @return [Boolean] true if this point's coordinates match other_point's
  def == other_point
    coords == other_point.coords
  end

  # Returns an array representing the x and y coordinates of this point.
  #
  # @return [Array] this point's coordinates
  def coords
    [x, y]
  end

  # Translate this point down by the specified distance.
  #
  # Increases the y coordinate.
  #
  # @param n [Integer] the distance to move
  # @return [Point] a new point representing the new position
  def down n = 1
    self.class.new @x, @y + n
  end

  # Translate this point right by the specified distance.
  #
  # Increases the x coordinate.
  #
  # @param n [Integer] the distance to move
  # @return [Point] a new point representing the new position
  def right n = 1
    self.class.new @x + n, @y
  end

  # Translate this point left by the specified distance.
  #
  # Decreases the x coordinate.
  #
  # @param n [Integer] the distance to move
  # @return [Point] a new point representing the new position
  def left n = 1
    right -n
  end

  # Translate this point left by the specified distance.
  #
  # Decreases the y coordinate.
  #
  # @param n [Integer] the distance to move
  # @return [Point] a new point representing the new position
  def up n = 1
    down -n
  end

  # returns a list of adjacent points
  #
  # NOTE: This method may return points that are illegal on the current board!
  #
  # @return [Array<Point>] adjacent points
  def neighbors
    [ down, left, right, up ]
  end

end
