module Given
  module DSL

    def Given(*args, &block)
      _given_levels.push(eval("__LINE__", block))
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
      _given_levels.pop
    end

    def When(&when_code)
      _given_must_have_given_context("When")
      @given_when = when_code
    end

    def _given_test_name(setup_codes, when_code, then_code)
      tags = _given_levels.map { |ln| "G#{ln}" }
      tags << ("W" + eval("__LINE__", when_code).to_s)
      if then_code
        tags << ("T" + eval("__LINE__", then_code).to_s)
      end
      "test__#{tags.join('_')}_"
    end

    def _given_make_test_method(then_code, exception_class)
      setups = @given_setups
      when_code = @given_when
      invariant_codes = @given_invariants
      define_method _given_test_name(setups, when_code, then_code) do
        setups.each do |s| send s end
        if exception_class.nil?
          instance_eval(&when_code)
        else
          begin
            instance_eval(&when_code)
            given_assert(lambda { false })
          rescue exception_class => ex
            @exception = ex
          end
        end
        given_assert(then_code) unless then_code.nil?
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

    def _given_levels
      @given_levels ||= []
    end

    def _given_must_have_given_context(clause)
      fail UsageError, "A #{clause} clause must be inside a given block" if
        _given_levels.size <= 0
    end
  end
end
