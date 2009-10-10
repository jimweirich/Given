require 'test/test_helper'

require 'given'

class SetupTest < GivenTestCase
  def test_given_setup_is_run
    assert_all_pass do
      Given(:a_number) do
        Then { @number == 10 }
      end
      def a_number
        @number = 10
      end
    end
  end

  def test_multiple_setups_are_run
    assert_all_pass do
      Given(:a_number, :another_number) do
        Then { @number == 10 && @another_number == 20 }
      end
      def a_number
        @number = 10
      end
      def another_number
        @another_number = 20
      end
    end
  end

  def test_setups_can_nest
    assert_all_pass do
      Given(:a_number) do
        Given(:another_number) do
          Then { @number == 10 && @another_number == 20 }
        end
      end
      def a_number
        @number = 10
      end
      def another_number
        @another_number = 20
      end
    end
  end

  def test_nested_setups_clean_up
    assert_all_pass do
      Given(:set_nil) do
        Given(:set_non_nil) do
        end
        Then { @stuff.nil? }
      end
      def set_nil
        @stuff = nil
      end
      def set_non_nil
        @stuff = :non_nil
      end
    end
  end

  def test_nested_setups_clean_up_even_with_errors
    assert_all_pass do
      Given(:set_nil) do
        Given(:set_non_nil) do
          fail "OOPS"
        end rescue nil
        Then { @stuff.nil? }
      end
      def set_nil
        @stuff = nil
      end
      def set_non_nil
        @stuff = :non_nil
      end
    end
  end
end
