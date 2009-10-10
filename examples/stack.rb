class Stack
  def initialize
    @items = []
  end

  def size
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
    @items.pop
  end
end
