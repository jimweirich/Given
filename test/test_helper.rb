require 'test/unit'
require 'given'
require 'given/test_unit/adapter'

class GivenTestCase < Test::Unit::TestCase
  private

  # Reach inside the tally object and return the first failure message
  def failure_message(tally)
    failures = tally.instance_eval { @failures }
    failures.first.instance_eval { @message }
  end

  def assert_all_pass(run_count=nil, &block)
    tally = run_tests(&block)
    assert tally.passed?, tally.inspect
    unless run_count.nil?
      assert_equal(run_count, tally.run_count,
        "Wrong number of test runs")
    end
  end

  def run_tests(&block)
    tests = test_class(&block)
    suite = tests.suite
    tally = Test::Unit::TestResult.new
    suite.run(tally) { }
    tally
  end

  def test_class(&block)
    Class.new(GivenFauxTestCase, &block)
  end

  def default_test
  end
end  

# Fake TestCase for testing.  This has everything the real
# Test::Unit::TestCase has, except that it won't trigger auto-testing.
# We use this to construct test cases.
class FauxTestCase
  include Test::Unit::Assertions
  include Test::Unit::Util::BacktraceFilter
  extend Given::DSL
  
  attr_reader :method_name
  
  STARTED = name + "::STARTED"
  FINISHED = name + "::FINISHED"
  
  ##
  # These exceptions are not caught by #run.
  
  PASSTHROUGH_EXCEPTIONS = [NoMemoryError, SignalException, Interrupt,
    SystemExit]
  
  # Creates a new instance of the fixture for running the
  # test represented by test_method_name.
  def initialize(test_method_name)
    unless(respond_to?(test_method_name) and
        (method(test_method_name).arity == 0 ||
          method(test_method_name).arity == -1))
      throw :invalid_test
    end
    @method_name = test_method_name
    @test_passed = true
  end
  
  # Rolls up all of the test* methods in the fixture into
  # one suite, creating a new instance of the fixture for
  # each method.
  def self.suite
    method_names = public_instance_methods(true)
    tests = method_names.delete_if {|method_name| method_name !~ /^test./}
    suite = Test::Unit::TestSuite.new(name)
    tests.sort.each do
      |test|
      catch(:invalid_test) do
        suite << new(test)
      end
    end
    if (suite.empty?)
      catch(:invalid_test) do
        suite << new("default_test")
      end
    end
    return suite
  end
  
  # Runs the individual test method represented by this
  # instance of the fixture, collecting statistics, failures
  # and errors in result.
  def run(result)
    yield(STARTED, name)
    @_result = result
    begin
      setup
      __send__(@method_name)
    rescue Test::Unit::AssertionFailedError => e
      add_failure(e.message, e.backtrace)
    rescue Exception
      raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
      add_error($!)
    ensure
      begin
        teardown
      rescue Test::Unit::AssertionFailedError => e
        add_failure(e.message, e.backtrace)
      rescue Exception
        raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
        add_error($!)
      end
    end
    result.add_run
    yield(FINISHED, name)
  end
  
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
  end
  
  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
  end
  
  def default_test
    flunk("No tests were specified")
  end
  
  # Returns whether this individual test passed or
  # not. Primarily for use in teardown so that artifacts
  # can be left behind if the test fails.
  def passed?
    return @test_passed
  end
  private :passed?
  
  def size
    1
  end
  
  def add_assertion
    @_result.add_assertion
  end
  private :add_assertion
  
  def add_failure(message, all_locations=caller())
    @test_passed = false
    @_result.add_failure(Test::Unit::Failure.new(name, filter_backtrace(all_locations), message))
  end
  private :add_failure
  
  def add_error(exception)
    @test_passed = false
    @_result.add_error(Test::Unit::Error.new(name, exception))
  end
  private :add_error
  
  # Returns a human-readable name for the specific test that
  # this instance of TestCase represents.
  def name
    "#{@method_name}(#{self.class.name})"
  end
  
  # Overridden to return #name.
  def to_s
    name
  end
  
  # It's handy to be able to compare TestCase instances.
  def ==(other)
    return false unless(other.kind_of?(self.class))
    return false unless(@method_name == other.method_name)
    self.class == other.class
  end
end


class GivenFauxTestCase < FauxTestCase
  include Given::TestUnit::Adapter

  # A track array is used by many tests to record the order of events.
  def a_track
    @track = []
  end
end
