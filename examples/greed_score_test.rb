require 'test/unit'
require 'given/test_unit'

module Greed
  class Score
    attr_reader :points, :unused

    def self.for(dice)
      @score = new
      @score.score(dice)
      @score
    end

    def initialize(points=0, unused=0)
      @points = points
      @unused = unused
    end

    def to_s
      "score<#{points},#{unused}>"
    end

    def ==(other)
      other.kind_of?(Greed::Score) &&
        points == other.points &&
        unused == other.unused
    end

    def score(dice)
      (1..6).each do |face|
        score_face(count_faces(face, dice), face)
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
      dice.select { |f| f == face}.size
    end

  end
end


class GreedScoreTest < Given::TestCase
  def score(dice)
    @score = Greed::Score.for(dice)
    expect(@score.points)
  end

  Given do
    Then { score([]) == 0 }
    Then { score([5]) == 50 }
    Then { score([5,5]) == 100 }
    Then { score([1]) == 100 }
    Then { score([1,1]) == 200 }
    Then { score([1,5,2,3,6]) == 150 }
    Then { score([1,1,1]) == 1000 }
    Then { score([2,2,2]) == 200 }
    Then { score([3,3,3]) == 300 }
    Then { score([1,1,1,1]) == 1100 }
    Then { score([5,5,5,5]) == 550 }
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
