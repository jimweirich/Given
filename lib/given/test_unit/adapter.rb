require 'test/unit'

module Test
  module Unit
    module Assertions
      
      #  The new <code>assert()</code> calls this to interpret
      #  blocks of assertive statements.
      #
      def instance_assert(instance, &block)
        begin
          ok = instance.instance_eval(&block)
          assert ok
          return ok if ok

        # rescue FlunkError
        #   raise  #  asserts inside assertions that fail do not decorate the outer assertion
        rescue => got
#          add_exception got
        end
        
        puts "DBG: diagnose(diagnostic, got, caller[1], options, block)=#{diagnose(diagnostic, got, caller[1], options, block).inspect}"
        flunk diagnose(diagnostic, got, caller[1], options, block)
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
