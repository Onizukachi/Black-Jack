module BoardGame
  class CalcPlayerScores
    def self.call(player)
      total = player.cards.sum(&:value)
      ace_count = player.cards.count(&:ace?)

      while ace_count.positive? && total > 21
        total -= 10
        ace_count -= 1
      end

      total
    end
  end
end