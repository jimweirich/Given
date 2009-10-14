require 'given/anonymous_code'

module Given
  class Code < AnonymousCode
    def initialize(mark, block)
      @mark = mark
      super(block)
    end

    def line_marker
      "%s%d" % [@mark, eval("__LINE__", @block)]
    end

    def file_line
      file = eval("__FILE__", @block)
      line = eval("__LINE__", @block)
      "#{file}:#{line}"
    end
  end
end
