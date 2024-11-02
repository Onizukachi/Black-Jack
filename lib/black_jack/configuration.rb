module BlackJack
  class Configuration
    attr_accessor :default_user_bank, :default_dealer_bank, :default_bet

    def initialize
      @default_user_bank = 100
      @default_dealer_bank = 100
      @default_bet = 10
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end
end
