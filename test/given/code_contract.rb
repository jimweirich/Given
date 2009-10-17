require 'test/unit'
require 'given/test_unit'
require 'given/code'

class CodeContract < Given::TestCase
  EXPECTED_LINE_MARKER_PATTERN = /^T\d+$/
  EXPECTED_FILE_LINE_PATTERN = /code_contract\.rb:\d+$/

  Given(:a_code_snippet) do
    Then { @code.run(self) == :result }
    Then { @code.line_marker =~ EXPECTED_LINE_MARKER_PATTERN }
    Then { @code.file_line =~ EXPECTED_FILE_LINE_PATTERN }
  end

  def a_code_snippet
    @code = Given::Code.new('T', lambda { :result })
  end
end
