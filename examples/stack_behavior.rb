require 'given/test_unit'
require 'examples/stack'

class StackBehavior < Given::Contract
  Invariant { @stack.empty? == (@stack.size == 0) }
  
  Given(:empty_stack) do
    Then { @stack.size == 0 }

    When { @stack.push(:an_item) }
    Then { @stack.size == 1 }
    Then { @stack.top == :an_item }
  end

  Given(:stack_with_two_items) {
    Then { @stack.top == :top_item }
    Then { @stack.size == 2}

    When { @result = @stack.pop }
    Then { @result == :top_item }
    Then { @stack.top == :bottom_item }
    Then { @stack.size == 1 }

    When {
      @stack.pop
      @result = @stack.pop
    }
    Then { @result == :bottom_item }
    Then { @stack.size == 0 }
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
