require 'rubygems'
require 'given/anonymous_code'
require 'given/code'
require 'assert2'

module Given
  module DSL
    module TestHelper
      def exception
        @_given_exception
      end

      def given_check(ok, msg, args)
        given_failure(msg % args) if ! ok
        true
      end

      def expect(value)
        Given::Expectation.new(value, self)
      end
    end

    private

    def Given(*args, &block)
      _given_levels.push(Code.new('G', block))
      @_given_setup_codes ||= []
      @_given_invariant_codes ||= []
      @_given_when_code = DO_NOTHING
      @_given_mock_codes = []
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
      @_given_mock_codes = []

      @_given_exception_class = nil
    end

    def Expecting(&mock_code)
      _given_must_have_context("Mock")
      @_given_mock_codes << AnonymousCode.new(mock_code)
      Then { true }
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
      mock_codes = @_given_mock_codes
      invariant_codes = @_given_invariant_codes
      define_method _given_test_name(setup_codes, when_code, then_code) do
        setup_codes.each do |s| send s end
        mock_codes.each do |m| m.run(self) end
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
        # given_assert(clause, then_code)
        instance_assert(self, &then_code)
        invariant_codes.each do |inv|
          # given_assert("Invariant", inv)
          instance_assert(self, &inv)
        end
      end
    end
  end
end
