# Thoughts on a new Ruby Specification Framework

I've been playing around with some ideas for a new
testing/specification framework for Ruby (because Ruby doesn't have
enough of them).  I've been trying to write down some of the
motivation for this, but that's taking too long.  I just want to get
some ideas down and published for review and we will address the whys
and wherefores later.

Essentially, I've been inspired by the Cucumber framework to bring the
given/when/then style of specifications directly into unit tests.  So
let's get right into it.

## Status

Given is now at a point where it is usable for small or experimental
projects.  I would love for people to give it a try and see how it
works out for them.  I wouldn't recommend it for anything mainstream
yet because the details of the API are still subject to change.

## Example Zero

Here's the spec that I've been playing with.  Its gone through
mulitple revisions and several prototype implementations.  And this is
probably not the final form.

With all that in mind, here's a specification in my imaginary
framework:

<pre>
require 'given/test_unit'
require 'examples/stack'

describe Stack do

  Invariant { stack.depth >= 0 }
  Invariant { stack.empty? == (stack.depth == 0) }

  context "an empty stack" do
    Given(:stack) { Stack.new }

    Then { stack.depth == 0 }

    Scenario "Popping an empty stack is an error"
    When { stack.pop }
    Then.fails(Stack::UsageError) { |ex|
      ex.message =~ /empty/i
    }

    Scenario "Pushing an item on the stack adds the item to the top"
    When { stack.push(:an_item) }
    Then { stack.depth == 1 }
    Then { stack.top == :an_item }
  end

  context "a stack with one item do
    Given(:stack) { Stack.new }
    Given { stack.push(:an_item) }

    Scenario "popping an item empties the stack"
    When { stack.pop }
    Then { result == :an_item }
    Then { stack.empty? }
  end

  context "a stack with several items" do
    Given(:stack) { Stack.new }
    Given { stack.push(:second_item) }
    Given { stack.push(:top_item) }
    Given(:old_depth) { stack.depth }

    Scenario "popping an item removes the top item"
    When { stack.pop }
    Then { result == :top_item }
    Then { stack.top == :second_item }
    Then.with { stack.depth }.compare { new == old-1 }
  end
end
</pre>

Let's talk about the individual sections.

### Given

The _Given_ section specifies a starting point, a set of preconditions
that must be true before the code under test is allowed to be run.  In
standard test frameworks the preconditions are established with a
combination of setup methods (or :before actions in RSpec) and code in
the test.

In the example code above, we see three starting points of interest.
One is an empty, just freshly created stack.  The next is a stack with
exactly one item.  The final starting point is a stack with several
items.

A precondition in the form "Given(:var) {...}" creates an accessor
method named "var".  The accessor is lazily initialized by the code
block.

A precondition in the form "Given {...}" just executes the code block
for side effects.

The preconditions are run in order of definition.  Nested contexts
will inherit the preconditions from the enclosing context, with out
preconditions running before inner preconditions.

### When

The _When_ block specifies the code to be tested ... oops, excuse me
... specified.  After the preconditions in the given section are met,
the when code block is run.

Each new _When_ block will start a new scenario.  Therefore, there may
be only one _When_ block for any given scenario.

### Then

The _Then_ sections are the postconditions of the specification. These
then conditions must be true after the code under test (the _When_
block) is run.

The code in the _Then_ block should be a single boolean condition that
evaluates to true if the code in the _When_ block is correct.  If the
_Then_ block evaluates to false, then that is recorded as a failure.

### Then.fails(error_class) { |ex| ...}

A special _Then_ form that specifies that _When_ block will throw an
exception.  The class of the exception must be either error\_class, or
a subclass of error\_class.  If a block is given for _Then.fails_,
then the block should return true (just as a normal _Then_ block
returns true).

### Then.with {...}.compare {...}

TBD

### Invariant

The _Invariant_ block is a new idea that doesn't have an analog in
RSpec or Test::Unit.  The invariant allows you specify things that
must always be true.  In the stack example, <tt>empty?</tt> is defined
in term of <tt>size</tt>.  Whenever <tt>size</tt> is 0,
<tt>empty?</tt> should be true.  Whenever <tt>size</tt> is non-zero,
<tt>empty?</tt> should be false.

You can conceptually think of an _Invariant_ block as a _Then_ block
that automatically gets added to every _When_ within its scope.

Invariants nested within a context only apply to the _When_ blocks in
that context.  

Invariants that reference a _Given_ precondition accessor must only be
used in contexts that define that accessor.

### Special accessors

The following accessor are special.

* _result_ -- returns the value of the _When_ block.  Useful to check
  the return values

* _old_ -- Returns the old value of the _Then_/_with_/_compare_
  expression.  The old value is captured immediately after the
  preconditions are established.  _old_ is only valid in a
  _Then_/_with_/_compare_.with

* _new_ -- Returns the new valud of the _Then_/_with_/_compare_
  expresion.  The new value is captured immediately after the _When_
  block is executed.  _new_ is only valid in a
  _Then_/_with_/_compare_.

## Summary

Feel free to comment on the ideas here.  Eventually I hope to have a
working prototype.
