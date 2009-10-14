class Stack
  class UsageError < RuntimeError
  end

  def initialize
    @items = []
  end

  def depth
    @items.size
  end

  def empty?
    @items.size == 0
  end

  def top
    @items.last
  end

  def push(item)
    @items.push(item)
  end

  def pop
    fail UsageError, "Cannot pop an empty stack" if empty?
    @items.pop
  end
end
