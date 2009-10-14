#!/usr/bin/env ruby

require 'test/unit'
require 'given/test_unit'

class AdapterTest < Given::Contract
  include Given::TestUnit::Adapter

  def add_assertion
    super
    @assertion_counted = true
  end

  Given do
    When { given_assert("Then", lambda { true }) }
    Then { @assertion_counted }

    When {
      @line = __LINE__ + 1
      given_assert("Then", lambda { false })
    }
    FailsWith(Test::Unit::AssertionFailedError) do
      Then { exception.message =~ /#{__FILE__}:#{@line}/ }
    end

    When {
      given_assert("Then", lambda { fail "OUCH" })
    }
    FailsWith(RuntimeError) do
      Then { exception.message == "OUCH" }
    end
  end
end
