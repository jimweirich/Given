module Given
  class TestUnitAdapter
    def initialize(tc)
      @tc = tc
    end

    # The assertion error used by the framework
    def self.assertion_failed_exception
      MiniTest::Assertion
    end

    # The assertion error used by the framework
    def assertion_failed_exception
      self.class.assertion_failed_exception
    end

    # Make an assertion within the framework
    def assert(instance, code)
      begin
        ok = instance.instance_eval(&code.block)
        @tc.instance_eval { self._assertions +=1 }
        return ok if ok
        
      rescue assertion_failed_exception => ex
        puts ex.backtrace
        raise
        
      rescue => got
        #          add_exception got
      ensure
      end
      
      @tc.flunk diagnose(got, code)
    end
    
    def diagnose(got, code)
      code.file_line
    end

    def given_failure(message, code=nil)
      if code
        message = "\n#{code.file_line} #{message}\n"
      end
      raise assertion_failed_exception.new(message)
    end
  end

end
