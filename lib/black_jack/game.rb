module BlackJack
  class Game
    attr_reader :user, :dealer, :players, :deck, :round

    def initialize
      Interface.welcome

      @user = User.new(Interface.username)
      @dealer = Dealer.new
      @players = [user, dealer]
    end

    def run
      make_bet

      loop do
        round = Round.new(players)
        round.play
        process_result round.result
        check_new_round
      end
    end

    private

    def make_bet = players.each { |player| player.do_bet(BlackJack.config.default_bet)}

    def process_result(result)
      Interface.clear
      result == :draw ? process_draw : process_winner(result)
      players_status
    end

    def players_status
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
      if user.bank > BlackJack.config.default_bet && Interface.continue == 'yes'
        make_bet
      else
        Interface.goodbye
        exit
      end
    end
  end
end
