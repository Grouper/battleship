require "minitest/autorun"
require_relative "../contestants/eden_player"

describe 'EdenPlayer' do

  it 'has a name' do
    name = EdenPlayer.new.name
    name.must_equal "Eden"
  end

end