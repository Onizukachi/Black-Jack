# frozen_string_literal: true

module BlackJack
  class Player
    attr_reader :bank, :cards, :name

    def initialize(name = nil)
      @name = name || default_name
      @bank = BlackJack.config.default_user_bank
      @cards = []
    end

    def show_status(hidden: false)
      hidden ? Interface.hidden_player_status(self) : Interface.open_player_status(self)
    end

    def card_size
      cards.size
    end

    # @return [Symbol] will be one of the following values [:skip, :take_card, :show_cards]
    def make_move
      cards.count < 3 && scores < 17 ? :take_card : :skip
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
