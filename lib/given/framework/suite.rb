module Given
  module Framework
    class Suite
      def initialize
        @tests = []
      end
      def <<(test)
        @tests << test
        self
      end
      def run
        @tests.each do |t| t.run end
      end
    end
  end
end
