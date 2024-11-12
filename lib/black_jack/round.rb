module BlackJack
  class Round
    attr_reader :players, :deck, :status

    def initialize(players, deck)
      @players = players
      @deck = deck
      @status = 0
    end

    def start
      loop do
        Interface.clear
        status_bar

        players.each do |player|
          decision = player.make_move

          handle_decision(decision, player)
        end

        break if round_finished?
      end
    end

    def result
      return nil if players.map(&:scores).uniq.size == 1

      determine_winner
    end

    private

    def status_bar
      players.each { |player| player.is_a?(Dealer) ? player.show_status(hidden: true) : player.show_status }
      Interface.separator
    end

    def finish!
      @status = 1
    end

    def round_finished?
      !status.zero? || players_exceed_score_limit? || players_exceed_card_limit?
    end

    def handle_decision(decision, player)
      case decision
      when :take_card
        if player.card_size > 2
          Interface.exceed_card_limit
        else
          player.take_card(deck.give_card)
        end
      when :show_cards then finish!
      when :skip then nil
      end
    end

    def players_exceed_score_limit?
      players.map(&:scores).min > 21
    end

    def players_exceed_card_limit?
      players.map(&:card_size).all? { |card_size| card_size > 2 }
    end

    def determine_winner
      valid_players = players.select { |player| player.scores <= 21 }

      return valid_players.max_by(&:scores) if valid_players.any?

      players.min_by(&:scores)
    end
  end
end
