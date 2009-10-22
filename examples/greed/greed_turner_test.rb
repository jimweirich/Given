require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

require 'rubygems'
require 'flexmock/test_unit'
require 'greed/turner'
require 'greed/score'

class TurnerTest < Given::TestCase
  Score = Greed::Score  

  def a_turner_with_a_player
    @rolls = []
    @dice = flexmock("dice")
    @dice.should_receive(:roll).with(Integer).
      and_return { |n| @rolls.shift[0,n] }
    @player = flexmock("player")
    @player.should_receive(:start_turn => nil,
      :roll_again? => false,
      :end_turn => nil).by_default
    @turner = Greed::Turner.new(@player, @dice)
  end

  def a_bust_roll
    @rolls << [2, 3, 4, 4, 6]
  end

  def a_good_roll
    @rolls << [1, 2, 2, 3, 3]
  end

  Given(:a_turner_with_a_player, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).never
      @player.should_receive(:end_turn).once.with(0)
    end
  end

  Given(:a_turner_with_a_player, :a_good_roll, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 4)).and_return(true)
      @player.should_receive(:end_turn).once.with(0)
    end
  end

  Given(:a_turner_with_a_player, :a_good_roll, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 4)).and_return(true)
      @player.should_receive(:end_turn).once.with(0)
    end
  end

  # Goal "Show that a player who stops after a good roll gets the score"
  Given(:a_turner_with_a_player, :a_good_roll, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 4)).and_return(false)
      @player.should_receive(:end_turn).once.with(100)
    end
  end

  Given(:a_turner_with_a_player, :a_good_roll, :a_good_roll, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 4)).and_return(true)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 3)).and_return(false)
      @player.should_receive(:end_turn).once.with(200)
    end
  end

  def two_good_rolls
    6.times { a_good_roll }
  end

  #Goal "Show that a turn ends when roll_again? returns false."
  Given(:a_turner_with_a_player, :two_good_rolls, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 4)).and_return(true)
      @player.should_receive(:roll_again?).once.with(Score.new(100, 3)).and_return(false)
      @player.should_receive(:end_turn).once.with(200)
    end
  end

  def six_good_rolls
    6.times { a_good_roll }
  end

  # Goal "Show that scoring all the dice resets number rolled to 5.
  Given(:a_turner_with_a_player, :six_good_rolls, :a_bust_roll) do
    When { @turner.take_turn(400) }
    Expects do
      @player.should_receive(:start_turn).once.with(0, 400)
      @player.should_receive(:roll_again?).and_return(true).times(5)
      @player.should_receive(:roll_again?).and_return(false)
      @player.should_receive(:end_turn).once.with(600)
    end
  end
end
