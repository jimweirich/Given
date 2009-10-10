#!/usr/bin/env ruby

require 'test/unit'
require 'given/framework'


class RawTest < Test::Unit::TestCase
  class RT < Given::Framework::TestCase
    def test_xyz
    end
  end
  
  def test_class_will_list_test_methods
    assert_equal [:test_xyz], RT.given_test_methods
  end

  def test_will_create_a_suite
    suite = RT.suite
    suite.run
  end
end
