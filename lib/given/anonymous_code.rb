module Given
  class AnonymousCode
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
  end

  DO_NOTHING = AnonymousCode.new(lambda { })
  TRUE_CODE  = AnonymousCode.new(lambda { true })
end
