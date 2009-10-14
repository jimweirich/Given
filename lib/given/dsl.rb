module Given
  module DSL

    private

    def Given(*args, &block)
      _given_levels.push(_given_line(block))
      @_given_setup_codes ||= []
      @_given_invariant_codes ||= []
      @_given_when_code = lambda { }
      old_setups = @_given_setup_codes
      old_invariants = @_given_invariant_codes
      @_given_setup_codes += args
      yield
    ensure
      @_given_setup_codes = old_setups
      @_given_invariant_codes = old_invariants
      @_given_when_code = lambda { }
      _given_levels.pop
    end

    def When(&when_code)
      _given_must_have_context("When")
      @_given_when_code = when_code
    end

    def Then(&then_code)
      _given_must_have_context("Then")
      _given_make_test_method("Then", then_code, nil)
    end

    def Fails(exception_class, &fail_code)
      _given_must_have_context("Fails")
      _given_make_test_method("Fails", fail_code, exception_class)
    end

    def Invariant(&block)
      @_given_invariant_codes ||= []
      @_given_invariant_codes += [block]
    end

    # Internal Use Methods -------------------------------------------

    def _given_line(block)
      eval("__LINE__", block)
    end

    def _given_levels
      @_given_levels ||= []
    end

    def _given_must_have_context(clause)
      fail UsageError, "A #{clause} clause must be inside a given block" if
        _given_levels.size <= 0
    end

    def _given_test_name(setup_codes, when_code, then_code)
      tags = _given_levels.map { |ln| "G#{ln}" }
      tags << ("W" + _given_line(when_code).to_s)
      if then_code
        tags << ("T" + _given_line(then_code).to_s)
      end
      "test__#{tags.join('_')}_"
    end

    def _given_make_test_method(clause, then_code, exception_class)
      setup_codes = @_given_setup_codes
      when_code = @_given_when_code
      invariant_codes = @_given_invariant_codes
      define_method _given_test_name(setup_codes, when_code, then_code) do
        setup_codes.each do |s| send s end
        if exception_class.nil?
          instance_eval(&when_code)
        else
          begin
            instance_eval(&when_code)
            given_failure("Expected #{exception_class} Exception")
          rescue exception_class => ex
            @exception = ex
          end
        end
        given_assert(clause, then_code) unless then_code.nil?
        invariant_codes.each do |inv|
          given_assert("Invariant", inv)
        end
      end
    end
  end
end
