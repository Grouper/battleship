class StupidPlayer
  MOVES = [[2,2],[2,3],[3,3],[3,2],[6,2],[6,3],[7,3],[7,2],[1,5],[2,5],[7,5],[8,5],[1,6],[2,6],[3,6],[4,6],[5,6],[6,6],[7,6],[8,6],[2,7],[3,7],[4,7],[5,7],[6,7],[7,7]]
 
  def initialize
    @turn = 0
  end
 
  def name
    "Stupid Brits"
  end
 
  def new_game
    [
      [0, 0, 5, :across],
      [0, 1, 4, :across],
      [0, 2, 3, :across],
      [0, 3, 3, :across],
      [0, 4, 2, :across]
    ]
  end
 
  def take_turn(state, ships_remaining)
    @turn += 1
    MOVES[@turn-1]
  end
end