require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class FauxContext
  include Given::GivenMatcher
end

describe "FauxContext" do
  context "basic faux context operation" do
    class FauxSample < FauxContext
      it do
        record << :done
      end
    end

    it "runs runs the it block" do
      @spec = FauxSample.new.run
      @spec.record.should == [:done]
    end
  end
end

describe "Given DSL" do
  context "with the simplest Given/Then" do
    class GivenThen < FauxContext
      Given { record << :given }
      Then  { record << :then }
    end

    before do
      @spec = GivenThen.new.run
    end

    it "runs the block in order" do
      @spec.record.should == [:given, :then]
    end

  end

  context "with multiple givens and a when" do
    class MultiGivens < FauxContext
      Given { record << :given1 }
      And   { record << :given2 }
      When  { record << :when }
      Then  { record << :then }
    end

    before do
      @spec = MultiGivens.new.run
    end

    it "runs all the blocks in order" do
      @spec.record.should == [:given1, :given2, :when, :then]
    end
  end

  context "with multiple givens and thens" do
    class MultiThens < FauxContext
      Given { record << :given1 }
      And   { record << :given2 }
      When  { record << :when }
      Then  { record << :then1 }
      Then  { record << :then2 }
    end

    before do
      @spec = MultiThens.new.run
    end

    it "runs all the blocks in order" do
      @spec.record.should == [
        :given1, :given2, :when, :then1,
        :given1, :given2, :when, :then2]
    end
  end

  context "with invariants" do
    class Inv < FauxContext
      Invariant { record << :inv1 }
      Invariant { record << :inv2 }

      Given { record << :given1 }
      Then  { record << :then1a }
      Then  { record << :then1b }

      Given { record << :given2 }
      Then  { record << :then2 }
    end

    before do
      @spec = Inv.new.run
    end

    it "runs all the blocks in order" do
      @spec.record.should == [
        :inv1, :inv2, :given1, :then1a,
        :inv1, :inv2, :given1, :then1b,
        :inv1, :inv2, :given2, :then2,
      ]
    end
  end
end

describe "DSL with variables in Given" do
  class GivenVars < FauxContext
    Given(:x) { 1 }
    And(:y) { 2 }
    When { record << x << y  }
    Then { record << 10*x << 10*y }
  end

  before { @spec = GivenVars.new.run }

  it 'has variables accessable in When and Then' do
    @spec.record.should == [1, 2, 10, 20]
  end
end

describe "DSL with failing conditions" do
  context "with failing thens" do
    class FailingThen < FauxContext
      Given { }
      Then  { false }
    end

    it "throws an RSpec exception" do
      lambda do
        FailingThen.new.run
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, /Error in block/)
    end
  end

  context "with failing invariants" do
    class FailingInv < FauxContext
      Invariant { false }
      Given { }
      Then  { true }
    end

    it "throws an RSpec exception from the invarient" do
      lambda do
        FailingInv.new.run
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, /Error in block/)
    end
  end
end
