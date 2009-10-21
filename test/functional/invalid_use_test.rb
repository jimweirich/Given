require 'test/test_helper'

class InvalidUseTest < GivenTestCase
  def test_then_must_be_inside_given
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Then {  }
      end
    end
    assert_equal "A Then clause must be inside a given block", ex.message
  end

  def test_then_must_be_inside_given_part_2
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Given do end
        Then {  }
      end
    end
    assert_equal "A Then clause must be inside a given block", ex.message
  end

  def test_when_must_be_inside_given
    ex = assert_raise(Given::UsageError) do
      run_tests do
        When {  }
      end
    end
    assert_equal "A When clause must be inside a given block", ex.message
  end

  def test_when_must_be_inside_given_part_2
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Given do end
        When {  }
      end
    end
    assert_equal "A When clause must be inside a given block", ex.message
  end

  def test_mock_must_be_inside_given
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Mock {  }
      end
    end
    assert_equal "A Mock clause must be inside a given block", ex.message
  end

  def test_mock_must_be_inside_given_part_2
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Given do end
        Mock {  }
      end
    end
    assert_equal "A Mock clause must be inside a given block", ex.message
  end

  def test_fails_with_must_be_inside_given
    ex = assert_raise(Given::UsageError) do
      run_tests do
        FailsWith(RuntimeError)
      end
    end
    assert_equal "A FailsWith clause must be inside a given block", ex.message
  end

  def test_fails_with_must_be_inside_given_part_2
    ex = assert_raise(Given::UsageError) do
      run_tests do
        Given do end
        FailsWith(RuntimeError)
      end
    end
    assert_equal "A FailsWith clause must be inside a given block", ex.message
  end
end
