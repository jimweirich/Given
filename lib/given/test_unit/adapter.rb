require 'test/unit'

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
