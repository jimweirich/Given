module Given
  module DSL
    def Given(*args)
      @setups ||= []
      @when = lambda { }
      old_setups = @setups
      @setups += args
      yield
    ensure
      @setups = old_setups
    end
    def When(&block)
      @when = block
    end
    def Then(&block)
      @test_counter ||= 0
      @test_counter += 1
      setups = @setups
      when_code = @when
      define_method "test_given__#{@test_counter}" do
        setups.each do |s| send s end
        instance_eval(&when_code)
        assert instance_eval(&block)
      end
    end
  end
end
