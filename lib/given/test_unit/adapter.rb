require 'test/unit'

module Test
  module Unit
    module Assertions
      
      #  The new <code>assert()</code> calls this to interpret
      #  blocks of assertive statements.
      #
      def instance_assert(instance, code)
        begin
          ok = instance.instance_eval(&code.block)
          self._assertions +=1 
          return ok if ok

        rescue Given.assertion_failed_exception => ex
          puts ex.backtrace
          raise

        rescue => got
          #          add_exception got

        ensure
        end
        
        flunk diagnose(got, code)
      end

      def diagnose(got, code)
        code.file_line
      end
    end
  end
end

module Given
  def self.assertion_failed_exception
    MiniTest::Assertion
  end

  module TestUnit
    module Adapter
      def given_failure(message, code=nil)
        if code
          message = "\n#{code.file_line} #{message}\n"
        end
        raise MiniTest::Assertion.new(message)
      end

      def given_assert(clause, code)
        ok = code.run(self)
        if ! ok
          given_failure("#{clause} Condition Failed", code)
        end
      end
    end
  end
end
