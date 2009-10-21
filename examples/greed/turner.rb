module Greed
  class Turner
    def initialize(player)
      @player = player
    end
    def take_turn
      @player.start_turn
      @player.end_turn
    end
  end
end
