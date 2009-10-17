require 'given'
require 'test/unit'
require 'given/test_unit/adapter'

module Given
  module TestCaseMethods
    def self.included(mod)
      mod.module_eval do
        extend Given::DSL
        include Given::DSL::TestHelper
        include Given::TestUnit::Adapter
      end
    end
  end

  class TestCase < Test::Unit::TestCase
    include Given::TestCaseMethods

    def test_DUMMY
    end
  end
end
