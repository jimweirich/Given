require 'given'
require 'test/unit'
require 'given/test_unit/adapter'

module Given
  class TestCase < Test::Unit::TestCase
    extend Given::DSL
    include Given::DSL::TestHelper
    include Given::TestUnit::Adapter

    def test_DUMMY
    end
  end
end
