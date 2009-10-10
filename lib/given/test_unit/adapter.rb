module Given
  module TestUnit
    module Adapter
      def given_assert(block)
        assert instance_eval(&block), "OK"
      end
    end
  end
end
