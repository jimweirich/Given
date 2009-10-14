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
    Fails(Test::Unit::AssertionFailedError) {
      @exception.message =~ /#{__FILE__}:#{@line}/
    }

    When {
      given_assert("Then", lambda { fail "OUCH" })
    }
    Fails(RuntimeError) {
      @exception.message == "OUCH"
    }
  end
end