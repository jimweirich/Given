require 'test/test_helper'

require 'given'

class ExpectsTest < GivenTestCase
  def test_mocks_are_called_before_when
    assert_all_pass do
      def trace
        @trace ||= []
      end
      Given do
        When { trace << :when }
        Expects { trace << :mock }
        Then { expect(trace) == [:mock, :when] }
      end
    end
  end

  def test_mocks_without_when_still_runs_a_test
    assert_all_pass do
      Given do
        Expects { }
      end
    end
  end

  def test_mocks_dont_leak_across_whens
    assert_all_pass do
      def trace
        @trace ||= []
      end
      Given do
        Expects { trace << :m1 }

        When { }
        Then { expect(trace) == [] }
      end
    end
  end

  def test_mocks_will_stack
    assert_all_pass do
      def trace
        @trace ||= []
      end
      Given do
        When { }
        Expects { trace << :m1 }
        Expects { trace << :m2 }
        Then { expect(trace) == [:m1, :m2] }
      end
    end
  end
end
