#!/usr/bin/env ruby

require 'test/unit'
require 'given/test_unit'

class AdapterTest < Given::TestCase
  include Given::TestUnit::Adapter

  Code = Given::Code

  def calls
    caller
  end

  Given do
    When { given_assert("Then", Code.new("T", calls, lambda { true })) }
    Then { true }

    When {
      @line = __LINE__ + 1
      given_assert("Then", Code.new('T', calls, lambda { false }))
    }
    FailsWith(MiniTest::Assertion) do
      Then {
        exception.message =~ /#{__FILE__}:#{@line}/
      }
    end

    When {
      given_assert("Then", Code.new('T', calls, lambda { fail "OUCH" }))
    }
    FailsWith(RuntimeError) do
      Then { exception.message == "OUCH" }
    end
  end
end
