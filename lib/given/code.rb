require 'given/anonymous_code'

module Given
  class Code < AnonymousCode
    def initialize(mark, block)
      @mark = mark
      super(block)
    end

    def line_marker
      file, line = file_line_pair
      "%s%d" % [@mark, line]
    end

    def file_line
      file, line = file_line_pair
      "#{file}:#{line}"
    end

    private

    def file_line_pair
      @file_line_pair ||= find_file_and_line
    end

    def find_file_and_line
      line = 0
      begin
        fail StandardError.new("OUCH")
      rescue StandardError => ex
        bt = ex.backtrace
        index = bt.size-1
        while index >= 0 && bt[index] !~ /\/dsl.rb/
          index -= 1
        end
        while index >= 0 && bt[index] =~ /\/dsl.rb/
          index -= 1
        end
        file, line = bt[index].split(":")
        return [file, line]
      end
      ["(UNKNOWN)", 0]
    end
  end
end
