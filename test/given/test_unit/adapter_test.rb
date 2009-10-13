#!/usr/bin/env ruby

require 'test/unit'
require 'given/test_unit'

class AdapterTest < Given::Contract
  include Given::TestUnit::Adapter

  Given do
    When { given_assert(lambda { true }) }
    Then { :ok }
  end

  def test_given_fails_with_file_and_line_with_false_block
    line = "xx"
    ex = assert_raise(Test::Unit::AssertionFailedError) do
      line = __LINE__ + 1
      given_assert(lambda { false })
    end
    assert_match(/#{__FILE__}:#{line}/, ex.message)
  end


  Given do
    When {
      given_assert(lambda { fail "OUCH" })
    }
    Fails(RuntimeError) {
      @exception.message == "OUCH"
    }
  end
  
  def test_given_fails_with_actual_exception
    ex = assert_raise(RuntimeError) do
      given_assert(lambda { fail "OUCH" })
    end
    assert_equal "OUCH", ex.message
  end
end
