module BlackJack
  class Dealer < Player
    def make_move = card_size < 3 && scores < 17 ? :take_card : :skip

    private def default_name = 'Дилер'
  end
end
