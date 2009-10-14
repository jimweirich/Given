require 'test/unit'

module Given
  module TestUnit
    module Adapter
      def given_failure(message, block)
        file = eval("__FILE__", block)
        line = eval("__LINE__", block)
        msg = "\n#{file}:#{line} #{message}\n"
        raise Test::Unit::AssertionFailedError.new(msg)
      end

      def given_assert(clause, block)
        _wrap_assertion do
          ok = instance_eval(&block)
          if ! ok
            given_failure("#{clause} Condition Failed", block)
          end
        end
      end
    end
  end
end
