module Bender
  class Ship
    attr_reader :x, :y, :length, :down
    def initialize(x, y, length, direction)
      @x, @y = x, y
      @length = length
      @down = direction == :down
    end

    def across
      !down
    end

    def extensions
      if down
        [ [x, y - 1], [x, y + length] ]
      else
        [ [x - 1, y], [x + length, y] ]
      end
    end

    def points
      (0...length).map{ |i| down ? [x, y + i] : [x + i, y] }
    end

    def member?(coord)
      points.member?( coord.to_a )
    end

    def ending?(coord)
      coord.to_a == points.first || coord.to_a == points.last
    end

    def segment(coord, size)
      return self if size == length
      x, y = coord.to_a
      if down
        y = points.map(&:last).min
        y = [(coord.y - size) + 1, y].max
      else
        x = points.map(&:first).min
        x = [(coord.x - size) + 1, x].max
      end
      self.class.new(x, y, size, down ? :down : :across)
    end

    def to_a
      [x, y, length, down ? :down : :across]
    end

    def inspect
      to_a.inspect
    end
    alias_method :to_s, :inspect

    def self.across(left, right)
      self.new(left.x, left.y, (right.x - left.x) + 1, :across)
    end

    def self.down(top, bottom)
      self.new(top.x, top.y, (bottom.y - top.y) + 1, :down)
    end
  end
end
