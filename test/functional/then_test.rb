require 'test/test_helper'

require 'given'

class ThenTest < GivenTestCase
  def test_then_passes_when_block_is_true
    assert_all_pass do
      Given do
        Then { true }
      end
    end
  end

  def test_then_fails_if_block_is_false
    tally = run_tests do
      Given do
        Then { false }
      end
    end
    assert ! tally.passed?
  end

  def test_multiple_thens_create_multiple_tests
    assert_all_pass(2) do
      Given do
        Then { true }
        Then { true }
      end
    end
  end

  def test_multiple_thens_with_tested_givens_create_multiple_tests
    assert_all_pass(3) do
      Given do
        Given do
          Then { true }
        end
        Then { true }
        Then { true }
      end
    end
  end
end
