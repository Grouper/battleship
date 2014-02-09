class Base

  AIRCRAFT_CARRIER = 5
  BATTLESHIP       = 4
  CRUISER          = 3
  SUBMARINE        = 2

  SHIPS = [AIRCRAFT_CARRIER, BATTLESHIP, CRUISER, CRUISER, SUBMARINE]

  def intialize
    setup
  end

  # Name your player
  def name
    raise 'Override this method in your player!'
  end

  # returns an array of starting positions
  #
  # This is called whenever a game starts. It must return the initial
  # positioning of the fleet as an array of 5 arrays, one for each ship. The
  # format of each array is:
  #
  #   [x, y, length, orientation]
  #
  # Where `x` and `y` are the top left cell of the ship, length is its length
  # (2-5), and orientation is either `:across` or `:down`.
  def new_game
    setup
  end

  # returns an array of co-ordinates for the next shot
  #
  # `state` is a representation of the known state of the opponent’s fleet,
  # as modified by the player’s shots. It is given as an array of arrays; the
  # inner arrays represent horizontal rows. Each cell may be in one of three
  # states: `:unknown`, `:hit`, or `:miss`. E.g.
  #
  #   [[:hit, :miss, :unknown, ...], [:unknown, :unknown, :unknown, ...], ...]
  #   # 0,0   1,0    2,0              0,1       1,1       2,1
  #
  # `ships_remaining` is an array of the ships remaining on the opponent's
  # board, given as an array of numbers representing their lengths, longest
  # first. For example, the first two calls will always be:
  #
  #   [5, 4, 3, 3, 2]
  #
  # If the player is lucky enough to take out the length 2 ship on their first
  # two turns, the third turn will be called with:
  #
  #   [5, 4, 3, 3]
  #
  # and so on.
  #
  # In the example above, we can see that the player has already played
  # `[0,0]`, yielding a hit, and `[1,0]`, giving a miss. They can now return a
  # reasonable guess of `[0,1]` for their next shot.
  def take_turn state, ships_remaining
    raise 'Override this method in your player!'
  end

private

  def setup
    raise 'Override this method in your player!'
  end

end
