require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

require 'greed/score'

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
