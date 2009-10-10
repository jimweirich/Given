require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'given/framework'

class SuiteTest < Test::Unit::TestCase
  def setup
    @suite = Given::Framework::Suite.new 
  end

  def test_can_add_tests
    t1 = flexmock("test 1")
    t1.should_receive(:run).once
    t2 = flexmock("test 2")
    t2.should_receive(:run).once
    
    @suite << t1 << t2

    @suite.run
  end
end
