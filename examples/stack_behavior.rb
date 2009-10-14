require 'given/test_unit'
require 'examples/stack'

class StackBehavior < Given::Contract
  Invariant { @stack.depth >= 0 }
  Invariant { @stack.empty? == (@stack.depth == 0) }

  Given(:empty_stack) do
    Then { @stack.depth == 0 }

    When { @stack.push(:an_item) }
    Then { @stack.depth == 1 }
    Then { @stack.top == :an_item }

    When { @stack.pop }
    Fails(Stack::UsageError) { @exception.message =~ /empty/ }
  end

  Given(:stack_with_two_items) {
    Then { @stack.top == :top_item }
    Then { @stack.depth == 2}

    When { @result = @stack.pop }
    Then { @result == :top_item }
    Then { @stack.top == :bottom_item }
    Then { @stack.depth == 1 }

    When {
      @stack.pop
      @result = @stack.pop
    }
    Then { @result == :bottom_item }
    Then { @stack.depth == 0 }
  }

  def empty_stack
    @stack = Stack.new
  end

  def stack_with_two_items
    empty_stack
    @stack.push(:bottom_item)
    @stack.push(:top_item)
  end
end
