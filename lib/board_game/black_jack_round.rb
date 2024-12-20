module BoardGame
  class BlackJackRound < Round
    attr_reader :players, :deck

    def initialize(players, deck)
      @players = players
      @deck = deck
      @finished = false
    end

    private

    def prepare_for_round
      discard_cards
      deal_initial_cards
    end

    def make_moves
      loop do
        status_bar

        players.each do |player|
          decision = player.make_move
          handle_decision(decision, player)
        end

        break if round_over?
      end
    end

    def discard_cards = players.each(&:discard_cards)
    def deal_initial_cards = 2.times { players.each { |player| player.take_card(deck.give_card) } }

    def status_bar
      players.each { |player| player.is_a?(Dealer) ? player.show_status(hidden: true) : player.show_status }
    end

    def finish! = @finished = true
    def finished? = @finished
    def round_over? = finished? || exceed_score_limit? || exceed_card_limit?

    def handle_decision(decision, player)
      case decision
      when :take_card then player.take_card(deck.give_card)
      when :show_cards then finish!
      when :skip then nil
      else nil
      end
    end

    def players_score = players.map { |player| CalcPlayerScores.call(player) }
    def exceed_score_limit? = players_score.max > 21
    def exceed_card_limit? = players.map(&:card_size).all? { |card_size| card_size > 2 }
    def draw? = players_score.uniq.size == 1

    def define_winner
      valid_players = players.select { |player| player.scores <= 21 }

      valid_players.any? ? valid_players.max_by(&:scores) : players.min_by(&:scores)
    end
  end
end
