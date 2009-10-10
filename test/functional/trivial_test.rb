require 'test/unit'
require 'given/test_unit'

require 'given/framework'


class TrivialPassingContract < Given::Framework::TestCase
  Given(:a_number) do
    Then { @number != nil }
  end
end


class TrivialTest < Test::Unit::TestCase
  def test_passes
    suite = TrivialPassingContract.suite
    suite.run
  end
end

