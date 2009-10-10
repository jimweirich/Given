require 'test/test_helper'

require 'given'

class WhenTest < GivenTestCase
  def test_whens_are_executed_after_all_setups_but_before_thens
    assert_all_pass do
      Given(:a, :b) do
        When { @track << :c }
        Then { @track == [:a, :b, :c] }
      end
      def a() @track = [:a] end
      def b() @track << :b end
    end
  end

  def test_whens_do_not_stack_linearly
    assert_all_pass do
      Given(:a_track) do
        When { @track << :a }
        Then { @track == [:a] }

        When { @track << :b }
        Then { @track == [:b] }
      end
    end
  end

  def test_whens_cleanup_from_nested_whens
    assert_all_pass do
      Given(:a_track) do
        When { @track << :a }

        Given do
          When { @track << :b }
          Then { @track == [:b] }
        end

        Then { @track == [] }
      end
    end
  end
end
