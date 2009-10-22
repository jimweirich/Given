# Greed is a dice game.  The rules to Greed varies, depending on who
# you talk to, but the rules we are using are:
#
# * You can roll up to 5 dice
#
# * Any triplet of ones is worth 1000
# 
# * Any triplet of any other face value is worth 100 times the face
#   value (e.g. 3 fours is worth 400 points)
#
# * Any ones not used in a triplet are worth 100 points
#
# * Any fives not used in a triplet are worth 50 points.
#
# * Any 2, 3, 4, or 6 faces not used in a triplet are worth 0 points
#   are are counted as unused dice.
#
module Greed
  # Score:
  # * Tracks the points for a roll of dice
  # * Reports the points for a roll
  # * Reports the number of unused faces in a roll.
  class Score
    attr_reader :points, :unused

    # Return the score object for a roll.  A roll is a list of
    # integers representing the faces showing after a roll of dice.
    def self.for(roll)
      @score = new
      @score.score(roll)
      @score
    end

    def initialize(points=0, unused=0)
      @points = points
      @unused = unused
    end

    def to_s
      "score<#{points},#{unused}>"
    end

    def inspect
      to_s
    end

    def ==(other)
      other.kind_of?(Greed::Score) &&
        points == other.points &&
        unused == other.unused
    end

    def remaining
      unused == 0 ? 5 : unused
    end

    def bust?
      points == 0
    end

    def +(previous_turn_score)
      bust? ? 0 : previous_turn_score + points
    end

    def score(roll)
      (1..6).each do |face|
        score_face(count_faces(face, roll), face)
      end
    end

    def score_face(count, face)
      if count >= 3 && face == 1
        count -= 3
        @points += 1000
      elsif count >= 3
        count -= 3
        @points += face * 100
      end
      if face == 1 || face == 5
        @points += count * score_single(face)
      else
        @unused += count
      end
    end

    def score_single(die)
      if die == 1
        100
      elsif die == 5
        50 
     else
        0
      end
    end

    def count_faces(face, dice)
      dice.select { |f| f == face }.size
    end

  end
end
