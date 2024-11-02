module BlackJack
  class Game
    attr_reader :user, :dealer, :deck, :round_status

    def initialize
      Interface.welcome

      @user = User.new(ask_user_name)
      @dealer = Dealer.new
      @deck = Deck.new
    end

    def run
      setup_round

      loop do
        Interface.clear
        display_status_bar

        user_move
        dealer_move

        round_finish! if finish_conditions
        Interface.clear
        process_round_result
      end
    end

    private

    def ask_user_name
      Interface.username

      user_input = gets.chomp
      user_input.empty? ? nil : user_input
    end

    def setup_round
      players = [user, dealer]
      players.each(&:discard_cards)
      players.each(&:do_bet)

      @deck.fill_deck.shuffle!

      2.times do
        players.each { |player| player.take_card(deck.give_card) }
      end

      round_start!
    end

    def round_start!
      @round_status = :started
    end

    def round_finished?
      round_status == :finished
    end

    def round_finish!
      @round_status = :finished
    end

    def display_status_bar
      Interface.open_player_status(user)
      round_finished? ? Interface.open_player_status(dealer) : Interface.hidden_player_status(dealer)
      Interface.separator
    end

    def user_move
      loop do
        Interface.actions
        user_input = gets.chomp.to_i

        case user_input
        when 1 then break
        when 2
          if user.cards.count < 3
            user.take_card(deck.give_card)
            break
          else
            Interface.exceed_card_limit
          end
        when 3
          round_finish!
          break
        else
          Interface.invalid_choice
        end
      end
    end

    def finish_conditions
      [user.scores, dealer.scores].min > 21 || (user.cards.count > 2 && dealer.cards.count > 2)
    end

    def dealer_move
      decision = DealerAIDecorator.new(dealer).make_decision
      return if decision == :skip

      dealer.take_card(deck.give_card)
    end

    def process_round_result
      return unless round_status == :finished

      if user.scores.equal?(dealer.scores)
        process_draw
      else
        winner = determine_winner
        process_winner(winner)
      end

      ending_move
    end

    def process_draw
      user.take_cache(BlackJack.config.default_bet)
      dealer.take_cache(BlackJack.config.default_bet)
      display_status_bar
      Interface.draw
    end

    def determine_winner
      if user.scores > 21 && dealer.scores > 21
        return user.scores < dealer.scores ? user : dealer
      end

      return dealer if user.scores > 21
      return user if dealer.scores > 21

      user.scores > dealer.scores ? user : dealer
    end

    def process_winner(winner)
      if winner.is_a?(User)
        user.take_cache(BlackJack.config.default_bet * 2)
        display_status_bar
        Interface.user_win
      else
        dealer.take_cache(BlackJack.config.default_bet * 2)
        display_status_bar
        Interface.user_lose
      end
    end

    def ending_move
      Interface.repeat_round
      user_input = gets.chomp

      if user_input == 'yes'
        setup_round
      else
        Interface.goodbye
        exit
      end
    end
  end
end
