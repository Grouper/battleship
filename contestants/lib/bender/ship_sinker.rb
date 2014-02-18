module Bender
  class ShipSinker
    attr_reader :game, :remaining

    def initialize(game, ships)
      @remaining = ships
      @sunk = []
      @unresolved = []
      @game = game
    end

    def update(remaining)
      sink_ship *@sunk
      sank = find_what_sank(remaining.sort)
      @unresolved << [sank, game.last.to_a] if sank
      try_placing_ships
      # handle_unresolved
      @remaining = remaining
    end

    def find_what_sank(current)
      sank = nil
      if @remaining.size != current.size
        @remaining.sort.each_with_index do |size, i|
          if size != current[i]
            sank = size
            break
          end
        end
      end
      sank
    end

    def try_placing_ships
      placed = 0
      begin
        placed = 0
        unresolved = []
        @unresolved.each do |size, xy|
          if place_ship(size, game.board.at(*xy))
            placed += 1
          else
            unresolved << [size, xy]
          end
        end
        @unresolved = unresolved
      end while placed > 0
    end

    def place_ship(size, coord)
      possible_ships = game.lines(game.board.hits).select do |line|
        # line.member?(coord) && line.length == size
        line.member?(coord) &&
        ( line.length == size || (line.length > size && line.ending?(coord)) )
      end
      case possible_ships.count
      when 1
        ship = possible_ships.first.segment(coord, size)
        sink_ship ship
        @sunk << ship
      when 2
        game.log <<-HEREDOC
Last move: #{game.last.to_a.inspect}
Coord: #{coord.inspect}
Sunk ships: #{@sunk.inspect}
Remaining: #{@remaining}
Multiple possible ships: #{possible_ships.inspect}
Unresolved: #{@unresolved}
Board:
#{game.board.inspect}
HEREDOC
      end
    end

    def sink_ship(*ships)
      ships.each do |ship|
        ship.points.each do |xy|
          game.board.at(*xy).status = :sunk
        end
      end
    end
  end
end
