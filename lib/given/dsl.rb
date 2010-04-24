
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
    
    def _given_invariants
      @_given_invariants ||= lambda { |spec| }
    end

    def _given_create_invariant_chain(block)
      previous_code = _given_invariants
      @_given_invariants = lambda { |spec|
        spec.instance_exec(spec, &previous_code)
        block.should be_given_evaluated(self)
      }
    end

    def _given_create_code_chain(block, var=nil)
      previous_code = @_given_code
      if var
        @_given_code = lambda { |spec|
          spec.instance_exec(spec, &previous_code)
          spec.instance_variable_set("@#{var}", spec.instance_exec(&block))
        }
      else
        @_given_code = lambda { |spec|
          spec.instance_exec(spec, &previous_code)
          spec.instance_exec(&block)
        }
      end
    end
    
    def Invariant(&block)
      _given_create_invariant_chain(block)
    end

    def Given(var=nil, &block)
      invariants = _given_invariants
      @_given_code = lambda { |spec|
        spec.instance_exec(spec, &invariants)
      }
      define_method(var) { instance_variable_get("@#{var}") } if var
      _given_create_code_chain(block, var)
    end
    
    def And(var=nil, &block)
      define_method(var) { instance_variable_get("@#{var}") } if var
      _given_create_code_chain(block, var)
    end
    
    def When(&block)
      _given_create_code_chain(block)
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
