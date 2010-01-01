require 'test/test_helper'

require 'given'

class InvariantTest < GivenTestCase
  def test_failing_invariants_fail_all_thens
    tally = run_tests do
      Given do
        Invariant { false }
        Then { true }
        Then { true }
      end
    end
    assert ! tally.passed?
    assert_equal 2, tally.failure_count
  end

  def test_multiple_invariants_are_all_checked_part_1
    tally = run_tests do
      Given do
        Invariant { false }
        Invariant { true }
        Then { true }
      end
    end
    assert ! tally.passed?
  end

  def test_multiple_invariants_are_all_checked_part_2
    tally = run_tests do
      Given do
        Invariant { true }
        Invariant { false }
        Then { true }
      end
    end
    assert ! tally.passed?
  end

  def test_failing_global_invariants_fail_all_thens
    line = 0
    tally = run_tests do
      line = __LINE__ + 1
      Invariant { false }
      Given do
        Then { true }
        Then { true }
      end
    end
    assert ! tally.passed?
    assert_equal 2, tally.failure_count
    assert_match(/:#{line}/, failure_message(tally))
  end

  def test_invariants_run_after_given_setup
    assert_all_pass do
      Invariant { ! @track.nil? }
      Given(:a_track) do
        Invariant { ! @track.nil? }

        Then { @track == [] }

        When { @track << :w }
        Then { @track == [:w] }
      end
    end
  end

  def test_invariants_nest_with_givens
    assert_all_pass do
      Given(:a_track) do
        Invariant { ! @track.nil? }

        Given(:a_track_with_b) do
          Invariant { @track == [:b] }
          Then { @track == [:b] }
        end

        Then { @track == [] }
      end
      def a_track_with_b
        @track << :b
      end
    end
  end
end
