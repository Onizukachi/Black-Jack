module BoardGame
  class Round
    def play
      prepare_for_round
      make_moves
    end

    def result = draw? ? :draw : define_winner

    private

    def prepare_for_round; end
    def make_moves; end
    def draw?; end
    def define_winner; end
  end
end