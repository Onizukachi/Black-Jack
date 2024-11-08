module BlackJack
  class Interface
    class << self
      def welcome
        puts "***Добро пожаловать в игру Блэк Джэк***\n\n"
      end

      def goodbye
        puts '***Спасибо за игру***'
      end

      def clear
        if Gem.win_platform?
          system 'cls'
        else
          system 'clear'
        end
      end

      def separator
        puts '=' * 70
      end

      def username
        puts 'Введите ваше имя:'
      end

      def actions
        puts <<~TEXT
          Выберите действие
            1. Пропустить ход
            2. Добавить карту
            3. Открыть карты
        TEXT
      end

      def invalid_choice
        puts 'Такого действия не сущестует'
      end

      def open_player_status(player)
        puts [username_part(player.name),
              scores_part(player.scores),
              open_cards_part(player.cards),
              bank_part(player.bank)].join(' | ')
      end

      def hidden_player_status(player)
        puts [username_part(player.name), hidden_cards_part(player.cards), bank_part(player.bank)].join(' | ')
      end

      def draw
        puts 'У вас ничья с дилером!'
      end

      def user_win
        puts 'Поздравляем! Вы выиграли раунд'
      end

      def user_lose
        puts 'Упс! Вы проирали'
      end

      def repeat_round
        puts 'Желаете сыграть еще раз? (Введите yes если согласны)'
      end

      def exceed_card_limit
        puts 'Увы, но вас уже максимальное количество карт'
      end

      private

      def username_part(name)
        "Игрок: #{name}"
      end

      def scores_part(scores)
        "Очки: #{scores}"
      end

      def open_cards_part(cards)
        "Карты: #{cards.join(' ')}"
      end

      def hidden_cards_part(cards)
        "Карты: #{Array.new(cards.count, '*').join(' ')}"
      end

      def bank_part(amount)
        "В кармане сейчас #{amount}$"
      end
    end
  end
end
