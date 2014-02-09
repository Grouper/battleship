require "minitest/autorun"
require_relative "../contestants/eden_player"

describe 'EdenPlayer' do

  it 'has a name' do
    name = EdenPlayer.new.name
    name.must_equal "Eden"
  end

  describe '#lay_ship' do
    describe 'generally, without a filter block' do
      it 'does not suggest a ship outside of the board range'
      it 'respects a limit parameter'
    end
    describe 'with a filter block' do
      it 'respects inclusion filters'
      it 'respects exclusion filters'
      it 'respects both filters simultaneously'
      it 'generates all possible combinations'
    end
  end

  describe '#position_aggregator' do
    it 'correctly aggregates the possible orientations from #lay_ship'
  end

  describe 'Offense' do
    it 'is more likely to choose a central spot early on'

    describe 'the parity rule' do
      it 'will obey the parity rule when in hunt mode'
      it 'will update the parity rule when ships are sunk'
    end

    describe 'responding to a hit' do
      it 'enters target mode'
    end

    describe 'responding to a sunk ship' do
      it 'reenters hunt mode'
    end

    describe "#next_target's suggestions" do
      it 'are within a plus shape of the hit'
      it 'are within the range of the longest ship available'
    end
  end

end