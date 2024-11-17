module BlackJack
  class Game
    attr_reader :user, :dealer, :players, :deck, :round

    def initialize
      Interface.welcome

      @user = User.new(Interface.username)
      @dealer = Dealer.new
      @deck = Deck
      @players = [user, dealer]
    end

    def run
      make_bet

      loop do
        Round.new(players, deck.new).play
        process_round_result
        check_new_round
      end
    end

    private

    def make_bet = players.each { |player| player.do_bet(BlackJack.config.default_bet)}

    def process_round_result
      Interface.clear
      draw? ? process_draw : process_winner
      players_status
    end

    def players_status
      Interface.separator
      players.each(&:show_status)
      Interface.separator
    end

    def draw? = players.map(&:scores).uniq.size == 1

    def process_draw
      players.each { |player| player.take_cache(BlackJack.config.default_bet) }

      Interface.draw
    end

    def process_winner
      winner = define_winner
      winner.take_cache(BlackJack.config.default_bet * 2)
      Interface.winner(winner.name)
    end

    def define_winner
      valid_players = players.select { |player| player.scores <= 21 }

      valid_players.any? ? valid_players.max_by(&:scores) : players.min_by(&:scores)
    end

    def check_new_round
      if Interface.continue == 'yes'
        make_bet
      else
        Interface.goodbye
        exit
      end
    end
  end
end
