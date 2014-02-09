module OpeningMoves

  def self.prepended base
    base.class_eval do
      attr_reader :opening_moves
    end
  end

  def take_turn *args
    @next_move ||= opening_moves.delete opening_moves.sample
    super
  end

end
