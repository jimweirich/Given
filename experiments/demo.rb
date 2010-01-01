#!/usr/bin/env ruby

require 'rubygems'
require 'ripper'
require 'sorcerer'

class EvalErr
  def initialize(str)
    @string = str
  end
  def size
    inspect.size
  end
  def to_s
    @string
  end
  def inspect
    @string
  end
end

def eval_in(exp, binding)
  eval(exp, binding).inspect
rescue StandardError => ex
  EvalErr.new("#{ex.class}: #{ex.message}")
end

def suggest_width(pairs)
  pairs.map { |x,v| v.size }.select { |n| n < 20 }.max || 10
end

def display_pairs(pairs)
  width = suggest_width(pairs)
  pairs.each do |x, v|
    if v.size > 20
      printf "%-#{width+2}s\n#{' '*(width+2)} <- %s\n", v, x
    else
      printf "%-#{width+2}s <- %s\n", v, x
    end
  end
end

def caller_line
  file, line = caller[1].split(/:/)
  [file, line]
end

require 'pp'

def run(&block)
  file, line = caller_line
  lines = open(file).readlines
  code = lines[line.to_i-1]
  sexp = Ripper::SexpBuilder.new(code).parse
  sexp = sexp[1][2][2][2]
  subs = Sorcerer.subexpressions(sexp).reverse.uniq.reverse
  pairs = subs.map { |exp|
    [exp, eval_in(exp, block.binding)]
  }
  display_pairs(pairs)
end

def f(n)
  n*n
end

a = 10
b = 2
c = 11
n = nil
p = ->(n) { n*n }
x = 'xyzzy'
hi = "hello"
there = "world"
run { 132 == (a + b) * c and x =~ /z+/ }
puts
run { f(f(f(f(a)))) * f(f(b)) }
puts
run { Math.sin(0.7) > 0.6 && Math.sin(0.7) < 0.8 }
puts
run { [4, 2, 6, 3, 7].sort.select { |n| n % 2 == 0 }.collect { |n| n*n } }
puts
run { hi.upcase + ', ' + there.capitalize }
puts
run { hi.upcase + ', ' + there.capitalize + n.downcase }
puts
run { a == b }
if RUBY_VERSION >= "1.9.2"
  puts
  run { p.(b) }
end
puts
run { a && (a+=2) && a }

