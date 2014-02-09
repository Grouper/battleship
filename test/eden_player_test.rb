require "minitest/autorun"
require_relative "../contestants/eden_player"

class EdenPlayerTest < MiniTest::Unit::TestCase

  def test_name
    name = EdenPlayer.new.name
    assert_equal name, "Eden"
  end

end