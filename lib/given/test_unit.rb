require 'given'
require 'test/unit'
require 'given/testunit/adapter'

module Given
  class Contract < Test::Unit::TestCase
    extend Given::DSL
    include Given::TestUnit::Adapter

    def test_DUMMY
    end
  end
end
