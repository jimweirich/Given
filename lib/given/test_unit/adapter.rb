require 'test/unit'

module Given
  module TestUnit
    module Adapter
      def given_assert(block)
        _wrap_assertion do
          ok = instance_eval(&block)
          if ! ok
            file = eval("__FILE__", block)
            line = eval("__LINE__", block)
            msg = "\n#{file}:#{line} Then Condition Failed\n"
            raise Test::Unit::AssertionFailedError.new(msg)
          end
        end
      end
    end
  end
end
