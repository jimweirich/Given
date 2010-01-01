module Given
  class AnonymousCode
    attr_reader :block

    def initialize(block)
      @block = block
    end
    
    def run(context)
      context.instance_eval(&@block)
    end

    def line_marker
      nil
    end

    def file_line
      nil
    end

    def to_proc
      @block
    end
    
    def inspect
      to_s
    end

    def to_s
      "<AnonymousCode@#{@block}>"
    end
  end

  DO_NOTHING = AnonymousCode.new(lambda { })
  TRUE_CODE  = AnonymousCode.new(lambda { true })
end
