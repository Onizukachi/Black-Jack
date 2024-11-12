# frozen_string_literal: true

module BlackJack
  class Deck
    SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
    RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze

    attr_reader :cards

    def initialize
      @cards = generate_cards
    end

    def shuffle!
      cards.shuffle!

      self
    end

    def give_card
      cards.shift
    end

    def generate_cards
      SUITS.product(RANKS).map do |suit, rank|
        Card.new(suit: suit, rank: rank)
      end
    end
  end
end
