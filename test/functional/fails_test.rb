require 'test/test_helper'
require 'given'

class FailsTest < GivenTestCase
  def test_fails_with_expected_failure_is_ok
    assert_all_pass do
      Given do
        When { fail "OUCH" }
        Fails(RuntimeError)
      end
    end
  end

  def test_actual_exception_is_passed_to_block
    assert_all_pass do
      Given do
        When { fail "OUCH" }
        Fails(RuntimeError) {
          @exception.class == RuntimeError &&
          @exception.message == "OUCH"
        }          
      end
    end
  end

  def test_failure_block_must_be_true
    tally = run_tests do
      Given do
        When { fail "OUCH" }
        Fails(RuntimeError) { 
          @exception.class == RuntimeError &&
          @exception.message == "XXXX"
        }          
      end
    end
    assert ! tally.passed?
  end

  def test_fails_without_expected_failure_is_not_ok
    tally = run_tests do
      Given do
        When { noop }
        Fails(RuntimeError)
      end
    end
    assert ! tally.passed?
  end

  def test_invariants_run_after_failure
    tally = run_tests do
      Given do
        Invariant { false }

        When { fail "OUCH" }
        Fails(RuntimeError)
      end
    end
    assert ! tally.passed?
  end

  # No Operation
  def noop
  end
end
