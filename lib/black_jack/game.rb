module BlackJack
  class Game
    attr_reader :user, :dealer, :players, :deck, :round

    def initialize
      Interface.welcome

      @user = User.new(ask_username)
      @dealer = Dealer.new
      @players = [user, dealer]
    end

    def run
      prepare_for_round

      loop do
        round.start
        winner = round.result
        Interface.clear
        process_round_result(winner)
        check_new_round
      end
    end

    private

    def ask_username
      user_input = Interface.username
      user_input.empty? ? nil : user_input
    end

    def prepare_for_round
      players.each(&:discard_cards)
      players.each(&:do_bet)
      @deck = Deck.new.shuffle!

      2.times { players.each { |player| player.take_card(deck.give_card) } }

      @round = Round.new(players, deck)
    end

    def process_round_result(winner)
      winner ? process_winner(winner) : process_draw

      Interface.separator
      players.each(&:show_status)
      Interface.separator
    end

    def process_draw
      players.each { |player| player.take_cache(BlackJack.config.default_bet) }
      Interface.draw
    end

    def process_winner(winner)
      winner.take_cache(BlackJack.config.default_bet * 2)
      Interface.winner(winner.name)
    end

    def check_new_round
      if Interface.continue == 'yes'
        prepare_for_round
      else
        Interface.goodbye
        exit
      end
    end
  end
end
