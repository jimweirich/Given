module Given
  module DSL
    def Given(*args)
      @setups ||= []
      old_setups = @setups
      @setups += args
      yield
    ensure
      @setups = old_setups
    end
    def Then(&block)
      @test_counter ||= 0
      @test_counter += 1
      setups = @setups
      define_method "test_given__#{@test_counter}" do
        setups.each do |s| send s end
        assert instance_eval(&block)
      end
    end
  end
end
