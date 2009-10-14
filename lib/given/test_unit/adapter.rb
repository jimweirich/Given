require 'test/unit'

module Given
  module TestUnit
    module Adapter
      def given_failure(message)
        raise Test::Unit::AssertionFailedError.new(message)
      end

      def given_assert(clause, block)
        _wrap_assertion do
          ok = instance_eval(&block)
          if ! ok
            file = eval("__FILE__", block)
            line = eval("__LINE__", block)
            msg = "\n#{file}:#{line} #{clause} Condition Failed\n"
            given_failure(msg)
          end
        end
      end
    end
  end
end
