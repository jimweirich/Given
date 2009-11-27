require 'test/unit'
require 'given/test_unit'
require 'given/anonymous_code'

class AnonymousCodeContract < Given::TestCase
  def an_anonymous_code_snippet
    @code = Given::AnonymousCode.new(lambda { :result })
  end

  Given(:an_anonymous_code_snippet) do
    Then { @code.run(self) == :result }
    Then { @code.line_marker.nil? }
    Then { @code.file_line.nil? }
  end
end
