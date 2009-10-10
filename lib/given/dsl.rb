module Given
  module DSL
    def Given(*args)
      yield
    end
    def Then
      define_method :test_something do end
    end
  end
end
