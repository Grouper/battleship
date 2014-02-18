module Bender
  class Board
    attr_reader :game

    def initialize(game)
      @game = game
    end

    def update(state)
      @coords = {}
      state.each_with_index do |row, y|
        row.each_with_index do |status, x|
          @coords[ [x, y] ] = Coord.new(game, x, y, status)
        end
      end
    end

    def at(x, y)
      @coords[ [x, y] ]
    end

    def misses
      all.select(&:miss?)
    end

    def hits
      all.select(&:hit?)
    end

    def available
      all.select(&:unknown?)
    end

    def sunk
      all.select(&:sunk?)
    end

    def all
      @coords.values
    end

    def inspect
      cols = (0..9)
      rows = (0..9)
      out = [[nil, *cols.map{|x| "(#{x})"}]]
      rows.each do |y|
        row = ["(#{y})"]
        cols.each do |x|
          row << at(x, y)
        end
        out << row
      end
      out.map{ |row| row.map{|v| v.to_s.rjust(8) }.join }.join("\n")
    end
  end
end
