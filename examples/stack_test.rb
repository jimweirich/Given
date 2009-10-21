require 'given/test_unit'
require 'examples/stack'

class StackBehavior < Given::TestCase
  Invariant { expect(@stack.depth) >= 0 }
  Invariant { expect(@stack.empty?) == (@stack.depth == 0) }

  def empty_stack
    @stack = Stack.new
  end

  Given(:empty_stack) do
    Then { expect(@stack.depth) == 0 }

    When { @stack.push(:an_item) }
    Then { expect(@stack.depth) == 1 }
    Then { expect(@stack.top) == :an_item }

    When { @stack.pop }
    FailsWith(Stack::UsageError)
    Then { expect(exception.message) =~ /empty/ }
  end

  def stack_with_two_items
    empty_stack
    @stack.push(:bottom_item)
    @stack.push(:top_item)
  end

  Given(:stack_with_two_items) {
    Then { expect(@stack.top) == :top_item }
    Then { expect(@stack.depth) == 2}

    When { @result = @stack.pop }
    Then { expect(@result) == :top_item }
    Then { expect(@stack.top) == :bottom_item }
    Then { expect(@stack.depth) == 1 }

    When {
      @stack.pop
      @result = @stack.pop
    }
    Then { expect(@result) == :bottom_item }
    Then { expect(@stack.depth) == 0 }
  }
end
