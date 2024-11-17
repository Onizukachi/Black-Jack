class Game
  def initialize
    @players = [Player.new('Player 1'), Player.new('Player 2')]
    @deck = Deck.new
  end

  def run
    make_bet
    Round.new(@deck, @players).start
    draw? ? process_draw : process_winner
  end

  private

  def make_bet = @players.each { |player| player.make_bet(10) }
  def draw? = @players.map(&:scores).uniq.size == 1
  def process_draw = puts "В результаты игры получилась ничья!"

  def process_winner
    winner = define_winner
    puts "В результаты игры победил #{winner.name}"
  end

  def define_winner
    valid_players = @players.select { |player| player.scores <= 21 }

    valid_players.any? ? valid_players.max_by(&:scores) : players.min_by(&:scores)
  end
end

class Player
  attr_reader :name, :bank, :cards

  def initialize(name)
    @name = name
    @cards = []
    @bank = 100
  end

  def scores = cards.sum(&:value)
  def card_size = cards.size
  def make_bet(amount) = @bank -= amount
  def make_move = @cards.size < 3 && scores < 17 ? :take_card : :skip
  def take_card(card) = @cards.push(card)
end

class Deck
  SUITS = %w[♠️ ♣️ ♥️ ♦️].freeze
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze

  def initialize
    @cards = generate_cards.shuffle!
  end

  def give_card = @cards.shift
  def generate_cards = SUITS.product(RANKS).map { |suit, rank| Card.new(suit: suit, rank: rank) }
end

Card = Struct.new(:suit, :rank, keyword_init: true) do
  def value = rank.is_a?(Integer) ? rank : 10
end

class Round
  def initialize(deck, players)
    @deck = deck
    @players = players
  end

  def start
    deal_initial_cards

    loop do
      @players.each do |player|
        player.take_card(@deck.give_card) if player.make_move == :take_card
      end

      break if round_over?
    end
  end

  def deal_initial_cards
    2.times { @players.each { |player| player.take_card(@deck.give_card) } }
  end

  private

  def round_over? = cards_exceed_limit? || scores_exceed?
  def cards_exceed_limit? = @players.map(&:card_size).all? { |card_size| card_size > 2 }
  def scores_exceed? = @players.map(&:scores).min > 21
end

Game.new.run
