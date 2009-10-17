require 'test/unit'
require 'given/test_unit'

class AnonymousCodeContract < Given::TestCase
  Given(:an_anonymous_code_snippet) do
    Then { @code.run = :result }
  end

  def an_anonymous_code_snippet
    @code = AnonymousCode.new("A", lambda { :result })
  end
end
