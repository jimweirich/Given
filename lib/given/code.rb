require 'given/anonymous_code'

module Given
  class Code < AnonymousCode
    attr_reader :file, :line

    def initialize(mark, call_stack, block)
      @mark = mark
      extract_file_and_line(call_stack.first)
      super(block)
    end

    def line_marker
      "%s%d" % [@mark, line]
    end

    def file_line
      "#{file}:#{line}"
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "<Code(#{@mark})@#{file_line}>"
    end

    private

    def extract_file_and_line(call_line)
      @file, line = call_line.split(":")
      @line = line.to_i
    end

    def file_line_pair
      [@file, @line]
    end
  end
end
