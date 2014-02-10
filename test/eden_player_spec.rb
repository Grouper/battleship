require "minitest/autorun"
require_relative "../contestants/eden_player"
require 'pry'

describe 'EdenPlayer' do
  before :each do
    @p = EdenPlayer.new
    @board = EdenPlayer.new_board
    @full_ship_set = [5, 4, 3, 3, 2]
  end

  it 'has a name' do
    name = @p.name
    name.must_equal "Eden"
  end

  describe '#next_hunting_point' do
    it 'is unlikely to choose a non-central spot early on' do
      pos = @p.next_hunting_point EdenPlayer.new_board
      pos[0].must_be_close_to 5, 2
      pos[1].must_be_close_to 5, 2
    end
    it 'will obey the parity rule when in hunt mode' do
      skip "todo"
    end
    it 'will update the parity rule when ships are sunk' do
      skip "todo"
    end
  end

  describe '#take_turn' do
    it 'does not make an initial invalid move' do
      turn = @p.take_turn(@board, @full_ship_set)
      turn.must_be_instance_of Array
    end
  end

  describe '#new_game' do
    it 'returns positions in the valid format' do
      positions = @p.new_game
      dirs = positions.map { |a| a.last }
      dirs.select { |s| s == :down || s == :across }.length.must_equal 5
      dirs = positions.map { |a| a[2] }
      dirs.select { |l| l >= 2 && l <= 5 }.length.must_equal 5
      dirs = positions.map { |a| a[0..1] }
      dirs.flatten.select { |l| l >= 0 && l <= 9 }.length.must_equal 10
    end
    it 'does not return any overlapping ships' do
      positions = @p.new_game
      dict = {down: EdenPlayer::DOWN, across: EdenPlayer::ACROSS}
      points = positions.map { |e| @p.body_from_head(Vector[*e[0..1]], e[2], dict[e[3]]) }
      points.flatten.uniq.count.must_equal 17
    end
  end

  describe '#probable_enemy_occupations' do
    before :each do
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

  describe '#aggregate_targets' do
    before(:each) do
      @board[5][5], @board[5][3] = [:hit, :miss]
    end
    it "doesn't recommend unreasonable points" do
      probs = @p.aggregate_targets(@board, @full_ship_set, [5, 5])
      probs.column_vectors[0..3].each do |e|
        e.to_a.must_equal Array.new(10) { 0 }
      end
    end
  end

  describe '#update_state' do
    before :each do
      @sunk_destroyer_set = [5, 4, 3, 3]
    end
    it 'switches to targeting mode after first hit' do
      @board[5][5] = :hit
      @p.update_state!(@board, @full_ship_set)
      @p.hunting.must_equal false
      @p.last_hit.must_equal [5,5]
      @p.opponents_ships.must_equal @full_ship_set
    end
    it 'maintains targeting mode after missing right after a hit' do
      # setup situation where first firing was a hit
      @board[5][5] = :hit
      @p.hunting = false
      @p.last_board = @board.dup
      @p.last_hit = [5,5]
      # after new action
      @board[5][4] = :miss
      @p.update_state!(@board, @full_ship_set)
      @p.hunting.must_equal false
      @p.last_hit.must_equal [5,5]
      @p.opponents_ships.must_equal @full_ship_set
    end
    it 'switches to hunting mode after sinking a ship' do
      # setup situation where first firing was a hit, 2nd was a miss
      @board[5][5], @board[5][4] = [:hit, :miss]
      @p.hunting = false
      @p.last_board = @board.dup
      @p.last_hit = [5,5]
      @p.opponents_ships = @full_ship_set
      # after a successful sink
      @board[5][6] = :hit
      @p.update_state!(@board, @sunk_destroyer_set)
      @p.hunting.must_equal true
      @p.opponents_ships.must_equal @sunk_destroyer_set
    end
  end
end
