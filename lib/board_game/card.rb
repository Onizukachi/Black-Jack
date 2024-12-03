module BoardGame
  Card = Struct.new(:suit, :rank, keyword_init: true) do
    def to_s
      "#{suit}#{rank}"
    end

    def ace?
      rank == 'A'
    end

    def value
      case rank
      when Integer
        rank
      when 'A'
        11
      else
        10
      end
    end
  end
end
