require 'greed/score'

module Greed
  class Turner
    def initialize(player, dice=d)
      @dice = dice
      @player = player
    end

    def take_turn(highest_score)
      @player.start_turn(0, highest_score)
      turn_score = 0
      score = Score.new(0,0)
      begin
        score = Score.for(@dice.roll(score.unused.nonzero? || 5))
        turn_score = score + turn_score
      end while ! score.bust? && @player.roll_again?(score)
      @player.end_turn(turn_score)
    end
  end
end
