module Given
  module DSL

    def Given(*args)
      @given_level = given_level + 1
      @given_setups ||= []
      @given_invariants ||= []
      @given_when = lambda { }
      old_setups = @given_setups
      old_invariants = @given_invariants
      @given_setups += args
      yield
    ensure
      @given_setups = old_setups
      @given_invariants = old_invariants
      @given_when = lambda { }
      @given_level -= 1
    end

    def When(&when_block)
      given_must_have_given_context("When")
      @given_when = when_block
    end

    def Then(&then_block)
      given_must_have_given_context("Then")
      @given_counter ||= 0
      @given_counter += 1
      setups = @given_setups
      when_code = @given_when
      invariant_codes = @given_invariants
      define_method "test_given__#{@given_counter}" do
        setups.each do |s| send s end
        instance_eval(&when_code)
        given_assert(then_block)
        invariant_codes.each do |inv|
          given_assert(inv)
        end
      end
    end

    def Fails(exception_class, &fail_code)
      given_must_have_given_context("Fails")
      @given_counter ||= 0
      @given_counter += 1
      setups = @given_setups
      when_code = @given_when
      invariant_codes = @given_invariants
      define_method "test_given__#{@given_counter}" do
        setups.each do |s| send s end
        begin
          instance_eval(&when_code)
          given_assert(lambda { false })
        rescue exception_class => ex
          @exception = ex
          given_assert(fail_code) if block_given?
        end
        invariant_codes.each do |inv|
          given_assert(inv)
        end
      end
    end

    def Invariant(&block)
      @given_invariants ||= []
      @given_invariants += [block]
    end

    def given_level
      @given_level ||= 0
    end

    def given_must_have_given_context(clause)
      fail UsageError, "A #{clause} clause must be inside a given block" if
        given_level <= 0
    end
  end
end
