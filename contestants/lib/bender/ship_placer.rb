module Bender
  class ShipPlacer
    attr_reader :game, :ships

    def initialize(game, ships)
      @game = game
      @ships = ships
    end

    def place
      placements = []
      points = []
      @ships.each do |size|
        new_ship = random_shipper(size).detect do |ship|
          ship.points.none?{ |p| points.member? p }
        end
        points += new_ship.points
        placements << new_ship
      end
      placements
    end

    def random_ship(size)
      max = 10 - (size - 1)
      if rand(2) == 0
        Ship.new rand(max), rand(10), size, :across
      else
        Ship.new rand(10), rand(max), size, :down
      end
    end

    def random_shipper(size)
      Enumerator.new do |y|
        loop do
          y << random_ship(size)
        end
      end
    end
  end
end
