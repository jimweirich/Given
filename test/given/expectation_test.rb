#!/usr/bin/env ruby

require 'test/unit'
require 'given/test_unit'

require 'given/expectation'

class ExpectationContract < Given::Contract
  Given do
    Then { expect(1) == 1 }
    Then { expect(2) > 1 }
    Then { expect(2) >= 1 }
    Then { expect(2) >= 2 }
    Then { expect(2) < 3 }
    Then { expect(2) <= 3 }
    Then { expect(2) <= 2 }
    Then { expect("abc") =~ /^a/ }
    Then { expect("abc").not =~ /^b/ }
    Then { expect(nil).nil? }
    Then { expect([]).empty? }
    Then { expect([1].size) == 1 }
  end

  Given do
    When { expect([]).size }
    FailsWith(Given::UsageError)
    Then { expect(exception.message) =~ /x/ }
  end

  Given do
    Then { expect(1).not == 2 }
    Then { expect(2).not <= 1 }
    Then { expect(2).not < 1 }
    Then { expect(2).not < 2 }
    Then { expect(2).not >= 3 }
    Then { expect(2).not > 3 }
    Then { expect(2).not > 2 }
    Then { expect("abc").not =~ /^b/ }
    Then { expect(1).not.nil? }
    Then { expect([1]).not.empty? }
    Then { expect([1,2].size).not == 1 }
  end

  Given do
    When { expect(1) == 2 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<1> expected to be equal to.*<2>/m }

    When { expect(1).not == 1 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<1> expected to not be equal to.*<1>/m }

    When { expect(2) > 3 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<2> expected to be greater than.*<3>/m }

    When { expect(3) < 2 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<3> expected to be less than.*<2>/m }
    
    When { expect(3) <= 2 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<3> expected to be less than or equal to.*<2>/m }
    
    When { expect(2) >= 3 }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<2> expected to be greater than or equal to.*<3>/m }
    
    When { expect("abc") =~ /^x/ }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<abc> expected to be matched by.*\^x/m }

    When { expect(1).nil? }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<1> expected to be nil/m }

    When { expect([1]).empty? }
    FailsWith(Given.assertion_failed_exception)
    Then { expect(exception.message) =~ /<1> expected to be empty\.?$/m }

  end

end
