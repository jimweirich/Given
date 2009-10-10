module Given
  module DSL

    def given_level
      @given_level ||= 0
    end

    def Given(*args)
      @given_level = given_level + 1
      @given_setups ||= []
      @invariants ||= []
      @when = lambda { }
      old_setups = @given_setups
      old_invariants = @invariants
      @given_setups += args
      yield
    ensure
      @given_setups = old_setups
      @invariants = old_invariants
      @when = lambda { }
      @given_level -= 1
    end

    def When(&block)
      given_must_have_given_context("When")
      @when = block
    end

    def Then(&block)
      given_must_have_given_context("Then")
      @test_counter ||= 0
      @test_counter += 1
      setups = @given_setups
      when_code = @when
      invariant_codes = @invariants
      define_method "test_given__#{@test_counter}" do
        setups.each do |s| send s end
        instance_eval(&when_code)
        assert instance_eval(&block)
        invariant_codes.each do |inv|
          assert instance_eval(&inv)
        end
      end
    end

    def Invariant(&block)
      @invariants ||= []
      @invariants += [block]
    end

    def given_must_have_given_context(clause)
      fail UsageError, "A #{clause} clause must be inside a given block" if
        given_level <= 0
    end
  end
end
