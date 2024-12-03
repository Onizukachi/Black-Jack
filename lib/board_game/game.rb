module BoardGame
  class Game
    attr_reader :user, :players, :deck, :round

    def initialize
      @user = User.new
      @players = [@user, Dealer.new]
      @deck = Deck.new
    end

    def start
      make_bet

      loop do
        round = BlackJackRound.new(players, deck)
        round.play
        process_result round.result
        check_new_round
      end
    end

    private

    def make_bet = players.each { |player| player.do_bet(BoardGame.config.default_bet)}

    def process_result(result)
      result == :draw ? process_draw : process_winner(result)
      players_status
    end

    def players_status = players.each(&:show_status)

    def process_draw
      players.each { |player| player.take_cache(BoardGame.config.default_bet) }
    end

    def process_winner(winner)
      winner.take_cache(BoardGame.config.default_bet * 2)
    end

    def check_new_round
      if user.bank > BoardGame.config.default_bet && Interface.continue == 'yes'
        make_bet
      else
        exit
      end
    end
  end
end
