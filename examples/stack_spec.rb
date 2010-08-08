
$: << '.' << '../lib'

require 'given'
require 'stack'

describe Stack do
  include Given::GivenMatcher
  extend Given::DSL

  def an_empty_stack
    Stack.new
  end

  def stack_with_two_items
    empty_stack
    @stack.push(:bottom_item)
    @stack.push(:top_item)
  end

  context "X" do
    Invariant { @stack.depth >= 0 }
    Invariant { @stack.empty? == (@stack.depth == 0) }

    Given { empty_stack }
    Then { @stack.depth == 0 }

    Given(:stack) { an_empty_stack }
    When { stack.push(:an_item) }
    Then { stack.depth == 1 }
    Then { stack.top == :an_item }

#   Given(:empty_stack)
#   When { @stack.pop }
#  FailsWith(Stack::UsageError)
#   Then { exception.message =~ /empty/ }

    Given { stack_with_two_items }
    Then { @stack.top == :top_item }
    Then { @stack.depth == 2}

    Given { stack_with_two_items }
    When { @result = @stack.pop }
    Then { @result == :top_item }
    Then { @stack.top == :bottom_item }
    Then { @stack.depth == 1 }

    Given { stack_with_two_items }
    When {
      @stack.pop
      @result = @stack.pop
    }
    Then { @result == :bottom_item }
    Then { @stack.depth == 0 }
  end

end
