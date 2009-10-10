module Given
  module DSL

    def Given(*args)
      @setups ||= []
      @invariants ||= []
      @when = lambda { }
      old_setups = @setups
      old_invariants = @invariants
      @setups += args
      yield
    ensure
      @setups = old_setups
      @invariants = old_invariants
      @when = lambda { }
    end

    def When(&block)
      @when = block
    end

    def Then(&block)
      @test_counter ||= 0
      @test_counter += 1
      setups = @setups
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
  end
end
