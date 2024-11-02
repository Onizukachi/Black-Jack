module BlackJack
  class DealerAIDecorator
    def initialize(dealer)
      @dealer = dealer
    end

    def make_decision
      @dealer.cards.count < 3 && @dealer.scores < 17 ? :take : :skip
    end
  end
end
