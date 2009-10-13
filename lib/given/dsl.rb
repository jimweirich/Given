module Given
  module DSL

    def Given(*args)
      @given_level = _given_level + 1
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

    def When(&when_code)
      _given_must_have_given_context("When")
      @given_when = when_code
    end

    def _given_make_test_method(then_code, exception_class)
      @given_counter ||= 0
      @given_counter += 1
      setups = @given_setups
      when_code = @given_when
      invariant_codes = @given_invariants
      define_method "test_given__#{@given_counter}" do
        setups.each do |s| send s end
        if exception_class
          begin
            instance_eval(&when_code)
            given_assert(lambda { false })
          rescue exception_class => ex
            @exception = ex
            given_assert(then_code) unless then_code.nil?
          end
        else
          instance_eval(&when_code)
          given_assert(then_code)
        end
        invariant_codes.each do |inv|
          given_assert(inv)
        end
      end
    end

    def Then(&then_code)
      _given_must_have_given_context("Then")
      _given_make_test_method(then_code, nil)
    end

    def Fails(exception_class, &fail_code)
      _given_must_have_given_context("Fails")
      _given_make_test_method(fail_code, exception_class)
    end

    def Invariant(&block)
      @given_invariants ||= []
      @given_invariants += [block]
    end

    def _given_level
      @given_level ||= 0
    end

    def _given_must_have_given_context(clause)
      fail UsageError, "A #{clause} clause must be inside a given block" if
        _given_level <= 0
    end
  end
end
