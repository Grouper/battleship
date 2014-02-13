require "minitest/autorun"
require "battleship/game"
require_relative '../contestants/eden_player'
require_relative '../players/stupid_player'
require 'pry'

describe 'Integration tests' do
  before :each do
    players = [
      StupidPlayer.new,
      EdenPlayer.new
    ]
    @game = Battleship::Game.new(10, [5,4,3,3,2], *players)
    @turns = 0.0
  end

  describe 'Full game against naive player' do
    it 'completes a game' do
      until @game.winner
        @game.tick
        @turns += 0.5
      end
      puts "took #{@turns.ceil} shots"
      @turns.must_be :<, 100
    end
  end
end
