module BlackJack
  class User < Player
    def make_move
      action_mapping = { 1 => :skip, 2 => :take_card, 3 => :show_cards }

      chosen_action = nil
      chosen_action = Interface.choose_action(self) until action_mapping[chosen_action]

      action_mapping[chosen_action]
    end

    private def default_name = 'Аноним'
  end
end
