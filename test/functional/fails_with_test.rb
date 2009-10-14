require 'test/test_helper'
require 'given'

class FailsTest < GivenTestCase
  def test_fails_with_expected_failure_is_ok
    assert_all_pass do
      Given do
        When { fail "OUCH" }
        FailsWith(RuntimeError)
      end
    end
  end

  def test_actual_exception_is_available
    assert_all_pass do
      Given do
        When { fail "OUCH" }
        FailsWith(RuntimeError)
        Then { exception.class == RuntimeError }
        And  { exception.message == "OUCH" }
      end
    end
  end

  def test_failure_block_must_be_true
    line = 0
    tally = run_tests do
      Given do
        When { fail "OUCH" }
        FailsWith(RuntimeError)
        Then { exception.class == RuntimeError }
        line = __LINE__ + 1
        And  { exception.message == "XXXX" }
      end
    end
    assert ! tally.passed?
    assert_match(/Then Condition Failed/, failure_message(tally))
    assert_match(/:#{line}/, failure_message(tally))
  end

  def test_fails_without_expected_failure_is_not_ok
    line = 0
    tally = run_tests do
      Given do
        line = __LINE__ + 1
        When { }
        FailsWith(RuntimeError)
      end
    end
    assert ! tally.passed?
    assert_match(/Expected RuntimeError Exception/i, failure_message(tally))
    assert_match(/:#{line}/, failure_message(tally))
  end

  class ExpectedError < RuntimeError
  end

  class ActualError < RuntimeError
  end

  def test_fails_with_unexpected_failure_is_not_ok
    line = 0
    tally = run_tests do
      Given do
        line = __LINE__ + 1
        When { fail ActualError }
        FailsWith(ExpectedError)
      end
    end
    assert ! tally.passed?
    assert_match(/Expected FailsTest::ExpectedError Exception/i,
      failure_message(tally))
    assert_match(/but got FailsTest::ActualError/i,
      failure_message(tally))
    assert_match(/:#{line}/, failure_message(tally))
  end

  def test_invariants_run_after_failure
    tally = run_tests do
      Given do
        Invariant { false }

        When { fail "OUCH" }
        FailsWith(RuntimeError)
      end
    end
    assert ! tally.passed?
  end

  # No Operation
  def noop
  end
end
