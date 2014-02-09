require "minitest/autorun"
require_relative "../contestants/eden_player"
require 'pry'

describe 'EdenPlayer' do
  before :each do
    @p = EdenPlayer.new
  end

  it 'has a name' do
    name = @p.name
    name.must_equal "Eden"
  end

  describe '#rand_pos' do
    it 'is unlikely to choose a non-central spot early on' do
      pos = @p.rand_pos EdenPlayer.new_board
      pos.first.must_be_close_to 5, 2
      pos.last.must_be_close_to 5, 2
    end
  end

  describe '#probable_enemy_occupations' do
    before :each do
      @board = EdenPlayer.new_board
      @expected_pattern = [0, 1, 2, 3, 4, 0, 4, 3, 2, 1]
    end

    it 'correctly finds ship orientations on an empty board' do
      @board[5][5] = :hit
      res = @p.probable_enemy_occupations ship_length: 5, board: @board, pos: [5, 5]
      res.must_be_instance_of Matrix
      res.column_vectors[5].to_a.must_equal @expected_pattern
      res.row_vectors[5].to_a.must_equal @expected_pattern
    end
    it 'correctly finds ship orientations on a more complex board' do
      @board[5][5] = :hit
      @board[5][4] = :miss
      res = @p.probable_enemy_occupations ship_length: 5, board: @board, pos: [5, 5]
      res.column_vectors[5].to_a.must_equal @expected_pattern
      res.row_vectors[5].to_a.must_equal [0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    end
  end

  describe '#lay_ship' do
    describe 'generally, without a filter block' do
      it 'does not suggest a ship outside of the board range' do
        skip "todo"
      end
      it 'respects a limit parameter' do
        skip "todo"
      end
    end
    describe 'with a filter block' do
      it 'respects inclusion filters' do
        skip "todo"
      end
      it 'respects exclusion filters' do
        skip "todo"
      end
      it 'respects both filters simultaneously' do
        skip "todo"
      end
      it 'generates all possible combinations' do
        skip "todo"
      end
    end
  end

  describe '#position_aggregator' do
    it 'correctly aggregates the possible orientations from #lay_ship' do
      skip "todo"
    end
  end

  describe 'Offense' do

    describe 'the parity rule' do
      it 'will obey the parity rule when in hunt mode' do
        skip "todo"
      end
      it 'will update the parity rule when ships are sunk' do
        skip "todo"
      end
    end

    describe 'responding to a hit' do
      it 'enters target mode' do
        skip "todo"
      end
    end

    describe 'responding to a sunk ship' do
      it 'reenters hunt mode' do
        skip "todo"
      end
    end

    describe "#next_target's suggestions" do
      it 'are within a plus shape of the hit' do
        skip "todo"
      end
      it 'are within the range of the longest ship available' do
        skip "todo"
      end
    end
  end
end