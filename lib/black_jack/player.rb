# frozen_string_literal: true

module BlackJack
  class Player
    attr_reader :bank, :cards, :name

    def initialize(name = nil)
      @name = name || default_name
      @bank = BlackJack.config.default_user_bank
      @cards = []
    end

    def take_card(card)
      cards.push(card)
    end

    def discard_cards
      cards.clear
    end

    def take_cache(amount)
      @bank += amount
    end

    def scores
      total = cards.sum(&:value)
      ace_count = cards.count(&:ace?)

      while ace_count.positive? && total > 21
        total -= 10
        ace_count -= 1
      end

      total
    end

    def do_bet
      @bank -= BlackJack.config.default_bet
    end

    private

    def default_name
      raise 'Not Implemented'
    end
  end
end
