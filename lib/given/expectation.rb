module Given
  class Expectation
    include Comparable

    def initialize(value, test_case)
      @value = value
      @test_case = test_case
    end

    def not()
      NegativeExpectation.new(@value, @test_case)
    end

    def evaluate_condition
      yield(@value)
    end

    def check(condition, msg, *args)
      bool = evaluate_condition(&condition)
      @test_case.given_check(bool,
        msg,
        [@value.inspect, twist] + args)
      true
    end

    def twist
      ""
    end

    def ==(other)
      check(
        lambda { |value| value == other },
        "<%s> expected to %sbe equal to\n<%s>.\n",
        other.inspect)
    end

    def >(other)
      check(lambda { |value| value > other },
        "<%s> expected to %sbe greater than\n<%s>.\n",
        other.inspect)
    end

    def <(other)
      check(lambda { |value| value < other },
        "<%s> expected to %sbe less than\n<%s>.\n",
        other.inspect)
    end

    def <=(other)
      check(lambda { |value| value <= other },
        "<%s> expected to %sbe less than or equal to\n<%s>.\n",
        other.inspect)
    end
    
    def >=(other)
      check(lambda { |value| value >= other },
        "<%s> expected to %sbe greater than or equal to\n<%s>.\n",
        other.inspect)
    end

    def =~(pattern)
      check(lambda { |value| value =~ pattern },
        "<%s> expected to %sbe matched by\n<%s>.\n",
        pattern.inspect)
    end

    def nil?
      check(lambda { |value| value.nil? },
        "<%s> expected to %sbe nil")
    end

    def method_missing(sym, *args, &block)
      method_name = sym.to_s
      if method_name =~ /\?$/
        check(lambda { |value| value.send(sym, *args, &block) },
          "<%s> expected to %sbe %s",
          method_name[0..-2])
      else
        fail Given::UsageError.new("cannot expect anything about #{sym}")
      end
    end
  end

  class NegativeExpectation < Expectation
    def evaluate_condition
      ! yield(@value)
    end
    def twist
      "not "
    end
  end
end
