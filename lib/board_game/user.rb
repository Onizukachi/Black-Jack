module BoardGame
  class User < Player
    def make_move = Interface.choose_action(self)

    private def default_name = 'Аноним'
  end
end
