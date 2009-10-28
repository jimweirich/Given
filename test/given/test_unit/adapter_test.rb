#!/usr/bin/env ruby

require 'test/unit'
require 'given/test_unit'

class AdapterTest < Given::TestCase
  include Given::TestUnit::Adapter

  Code = Given::Code

  def add_assertion
    super
    @assertion_counted = true
  end

  Given do
    When { given_assert("Then", Code.new("T", lambda { true })) }
    Then { @assertion_counted }

    When {
      @line = __LINE__ + 1
      given_assert("Then", Code.new('T', lambda { false }))
    }
    FailsWith(Test::Unit::AssertionFailedError) do
      Then {
        exception.message =~ /#{__FILE__}:#{@line}/
      }
    end

    When {
      given_assert("Then", Code.new('T', lambda { fail "OUCH" }))
    }
    FailsWith(RuntimeError) do
      Then { exception.message == "OUCH" }
    end
  end
end
