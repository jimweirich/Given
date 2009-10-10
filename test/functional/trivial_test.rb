require 'test/unit'
require 'test/faux_test_case'

require 'given'

class TrivialTest < Test::Unit::TestCase
  def test_trivial_passing_test_passes
    tests = Class.new(FauxTestCase) do
      Given do
        Then { true }
      end
    end
    suite = tests.suite
    tally = Test::Unit::TestResult.new
    suite.run(tally) { }
    assert tally.passed?
  end

  def test_trivial_failing_test_fails
    tests = Class.new(FauxTestCase) do
      Given do
        Then { false }
      end
    end
    suite = tests.suite
    tally = Test::Unit::TestResult.new
    suite.run(tally) { }
    assert ! tally.passed?
  end
  
end
