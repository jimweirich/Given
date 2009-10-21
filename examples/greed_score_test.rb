require 'test/unit'
require 'given/test_unit'

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


class GreedScoreTest < Given::TestCase
  def points(dice)
    @score = Greed::Score.for(dice)
    expect(@score.points)
  end

  Given do
    Then { points([]) == 0 }
    Then { points([5]) == 50 }
    Then { points([5,5]) == 100 }
    Then { points([1]) == 100 }
    Then { points([1,1]) == 200 }
    Then { points([1,5,2,3,6]) == 150 }
    Then { points([1,1,1]) == 1000 }
    Then { points([2,2,2]) == 200 }
    Then { points([3,3,3]) == 300 }
    Then { points([1,1,1,1]) == 1100 }
    Then { points([5,5,5,5]) == 550 }
  end

  def unused(dice)
    @score = Greed::Score.for(dice)
    expect(@score.unused)
  end

  Given do
    Then { unused([]) == 0 }
    Then { unused([1,5,2,2,2]) == 0 }
    Then { unused([1,5,2,2]) == 2 }
  end

  def a_zero_score
    @score = Greed::Score.new
  end

  Given(:a_zero_score) do
    Then { expect(@score.points) == 0 }
    Then { expect(@score.unused) == 0 }
    Then { expect(@score) == Greed::Score.new(0, 0) }
    Then { expect(@score).not == Greed::Score.new(1, 0) }
    Then { expect(@score).not == Greed::Score.new(0, 1) }
    Then { expect(@score).not == :non_score }
  end

end
