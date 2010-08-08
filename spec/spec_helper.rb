require 'given'

class FauxContext
  extend Given::DSL
  include Given::GivenMatcher

  def record
    @record ||= []
  end

  def run
    fail "No it block specified" if codes.empty?
    codes.each do |code|
      instance_exec(&code)
    end
    self
  end

  def codes
    self.class.codes
  end

  def self.it(description=nil, &block)
    codes << block
  end

  def self.codes
    @codes ||= []
  end
end
