require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

require 'rubygems'
require 'flexmock/test_unit'
require 'greed/turner'

class TurnerTest < Given::TestCase
  def a_turner_with_a_player
    @player = flexmock("player")
    @turner = Greed::Turner.new(@player)
  end

  Given(:a_turner_with_a_player) do
    When { @turner.take_turn }
    Mock { @player.should_receive(:start_turn).once }
    Mock { @player.should_receive(:end_turn).once }
    Then { true }
  end
end
