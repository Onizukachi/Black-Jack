module BlackJack
  class Interface
    class << self
      def welcome = puts "***Добро пожаловать в игру Блэк Джэк***\n\n"
      def goodbye = puts '***Спасибо за игру***'
      def clear = Gem.win_platform? ? system('cls') : system('clear')
      def separator = puts '=' * 70

      def username
        puts 'Введите ваше имя:'
        user_input = gets.chomp
        user_input.empty? ? nil : user_input
      end

      def choose_action(player)
        loop do
          puts 'Выберите действие'
          puts '1. Пропустить ход'
          puts '2. Добавить карту' if player.card_size < 3
          puts '3. Открыть карты'

          action = gets.chomp.to_i

          valid_actions = [1, 3]
          valid_actions << 2 if player.card_size < 3

          if valid_actions.include?(action)
            return action
          else
            puts 'Неправильный выбор. Попробуйте снова.'
          end
        end
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

      def draw = puts 'В результате раунда получилась ничья :)'
      def winner(name) = puts "Победителем этого раунда становится #{name}"

      def continue
        puts 'Желаете сыграть еще раз? (Введите yes если согласны)'
        gets.chomp
      end

      def exceed_card_limit
        puts 'Увы, но вас уже максимальное количество карт. Поэтому вы пропускаете ход!'
      end

      private

      def username_part(name) = "Игрок: #{name}"
      def scores_part(scores) = "Очки: #{scores}"
      def open_cards_part(cards) = "Карты: #{cards.join(' ')}"
      def hidden_cards_part(cards) = "Карты: #{Array.new(cards.count, '*').join(' ')}"
      def bank_part(amount) = "В кармане сейчас #{amount}$"
    end
  end
end
