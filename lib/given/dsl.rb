require 'given/code_block'

module Given
  class BeGivenEvaluated
    def initialize(spec)
      @spec = spec
    end

    def matches?(block)
      @block = block
      value = @spec.instance_exec(&block)
      value != false && !value.nil?
    end

    def failure_message_for_should
      "Error in block #{@block}"
      # evaluate(spec, &block)
    end

    def failure_message_for_should_not
      "Error in block -- shouldn't get this message"
    end
  end

  module GivenMatcher
    def be_given_evaluated(expected)
      Given::BeGivenEvaluated.new(expected)
    end
  end
end

module Given
  module DSL

    def _g__invariants
      @_g__invariants ||= []
    end


    def _g__test_code
      @_g__test_code ||= []
    end

    def _g__append_to_invariants(block)
      _g__invariants << block
    end

    def _g__append_to_test_code(block, var=nil)
      if var
        @_g__blocks << CodeBlock.new { |spec|
          spec.instance_variable_set("@#{var}", spec.instance_exec(&block))
        }
      else
        @_g__blocks << lambda { |spec|
          spec.instance_exec(&block)
        }
      end
    end

    def Invariant(&block)
      _g__invariants << CodeBlock.new(&block)
    end

    def Given(var=nil, &block)
      @_g__when_defined = false
      @_g__blocks = []
      define_method(var) { instance_variable_get("@#{var}") } if var
      _g__append_to_test_code(block, var)
    end

    def And(var=nil, &block)
      define_method(var) { instance_variable_get("@#{var}") } if var
      _g__append_to_test_code(block, var)
    end

    def When(&block)
      fail Given::UsageError, "When already defined" if @_g__when_defined
      @_g__when_defined = true
      _g__append_to_test_code(block)
    end

    def Then(&block)
      previous_code = @_g__blocks
      invariant_code = _g__invariants
      it "scenario" do
        previous_code.call(self)
        block.should be_given_evaluated(self)
        invariant_code.call(self)
      end
    end
  end
end
