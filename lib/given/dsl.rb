
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

    private

    def Invariant(&block)
      @_given_invariants ||= lambda { |spec| }
      previous_code = @_given_invariants
      @_given_invariants = lambda { |spec|
        spec.instance_exec(spec, &previous_code)
        block.should be_given_evaluated(self)
      }
    end

    def Given(&block)
      invariants = @_given_invariants || lambda { |spec| }
      @_given_code = lambda { |spec|
        spec.instance_exec(spec, &invariants)
      }
      And(&block)
    end
    
    def And(&block)
      previous_code = @_given_code
      @_given_code = lambda { |spec|
        spec.instance_exec(spec, &previous_code)
        spec.instance_exec(&block)
      }
    end
    
    def When(&block)
      previous_code = @_given_code
      @_given_code = lambda { |spec|
        spec.instance_exec(spec, &previous_code)
        spec.instance_exec(&block)
      }
    end

    def Then(&block)
      previous_code = @_given_code
      it "scenario" do
        previous_code.call(self)
        block.should be_given_evaluated(self)
      end
    end
  end
end
