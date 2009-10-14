require 'test/unit'

module Given
  module TestUnit
    module Adapter
      def given_failure(message, code)
        msg = "\n#{code.file_line} #{message}\n"
        raise Test::Unit::AssertionFailedError.new(msg)
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
