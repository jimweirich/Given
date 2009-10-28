require 'test/unit'

module Test
  module Unit
    module Assertions
      
      #  The new <code>assert()</code> calls this to interpret
      #  blocks of assertive statements.
      #
      def instance_assert(instance, diagnostic = nil, options = {}, &block)
        options[:keep_diagnostics] or add_diagnostic :clear
        
        begin
          if got = instance.instance_eval(&block)
            add_assertion
            return got
          end
        rescue FlunkError
          raise  #  asserts inside assertions that fail do not decorate the outer assertion
        rescue => got
          add_exception got
        end
        
        flunk diagnose(diagnostic, got, caller[1], options, block)
      end
    end
  end
end

module Given
  def self.assertion_failed_exception
    Test::Unit::AssertionFailedError
  end

  module TestUnit
    module Adapter
      def given_failure(message, code=nil)
        if code
          message = "\n#{code.file_line} #{message}\n"
        end
        raise Test::Unit::AssertionFailedError.new(message)
      end

      def given_assert(clause, code)
        _wrap_assertion do
          ok = code.run(self)
          if ! ok
            given_failure("#{clause} Condition Failed", code)
          end
        end
      end
    end
  end
end
