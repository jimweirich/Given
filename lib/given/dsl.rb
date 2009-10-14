module Given
  class AnonymousCode
    def initialize(mark, block)
      @mark = mark
      @block = block
    end
    
    def run(context)
      context.instance_eval(&@block)
    end

    def line_marker
      nil
    end

    def file_line
      nil
    end
  end

  DO_NOTHING = AnonymousCode.new('W', lambda { })
  TRUE_CODE  = AnonymousCode.new('T', lambda { true })

  class Code < AnonymousCode
    def line_marker
      "%s%d" % [@mark, eval("__LINE__", @block)]
    end

    def file_line
      file = eval("__FILE__", @block)
      line = eval("__LINE__", @block)
      "#{file}:#{line}"
    end
  end

  module DSL
    module TestHelper
      def exception
        @_given_exception
      end
    end

    private

    def Given(*args, &block)
      _given_levels.push(Code.new('G', block))
      @_given_setup_codes ||= []
      @_given_invariant_codes ||= []
      @_given_when_code = DO_NOTHING
      @_given_exception_class = nil
      old_setups = @_given_setup_codes
      old_invariants = @_given_invariant_codes
      @_given_setup_codes += args
      yield
    ensure
      @_given_setup_codes = old_setups
      @_given_invariant_codes = old_invariants
      @_given_when_code = DO_NOTHING
      _given_levels.pop
    end

    def When(&when_code)
      _given_must_have_context("When")
      @_given_when_code = Code.new('W', when_code)
      @_given_exception_class = nil
    end

    def Then(&then_code)
      _given_must_have_context("Then")
      _given_make_test_method("Then", Code.new('T', then_code), @_given_exception_class)
    end
    alias And Then

    def FailsWith(exception_class, &fail_code)
      _given_must_have_context("FailsWith")
      @_given_exception_class = exception_class
      _given_make_test_method("FailsWith", TRUE_CODE, exception_class)
      fail_code.call if fail_code
    end

    def Invariant(&block)
      @_given_invariant_codes ||= []
      @_given_invariant_codes += [Code.new('I', block)]
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
      tags = _given_levels.map { |code| code.line_marker }
      tags << when_code.line_marker
      if then_code
        tags << then_code.line_marker
      end
      tags.compact!
      sort = "%05d" % tags.last[1..-1].to_i
      "test__#{sort}_#{tags.join('_')}_"
    end

    def _given_make_test_method(clause, then_code, exception_class)
      setup_codes = @_given_setup_codes
      when_code = @_given_when_code
      invariant_codes = @_given_invariant_codes
      define_method _given_test_name(setup_codes, when_code, then_code) do
        setup_codes.each do |s| send s end
        if exception_class.nil?
          when_code.run(self)
        else
          begin
            when_code.run(self)
            given_failure("Expected #{exception_class} Exception", when_code)
          rescue exception_class => ex
            @_given_exception = ex
          rescue Exception => ex
            @_given_exception = ex
            given_failure("Expected #{exception_class} Exception, " +
              "but got #{exception.class}",
              when_code)
          end
        end
        given_assert(clause, then_code)
        invariant_codes.each do |inv|
          given_assert("Invariant", inv)
        end
      end
    end
  end
end
