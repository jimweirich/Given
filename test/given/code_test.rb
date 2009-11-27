require 'test/unit'
require 'given/test_unit'
require 'given/anonymous_code'

class CodeContract < Given::TestCase
  def a_code_snippet
    @code = Given::Code.new("T", lambda { :result })
  end

  Given(:a_code_snippet) do
    Then { @code.run(self) == :result }
    Then { @code.line_marker =~ /^T\d+$/ }
    Then { @code.file_line =~ /code_test\.rb:\d+$/ }
  end

  def a_line_marked_snippet
    @line = __LINE__ + 1
    @code = Given::Code.new("T", lambda { :result })
  end

  Given(:a_line_marked_snippet) do
    Then { @code.line_marker == "T#{@line}" }
  end
end
