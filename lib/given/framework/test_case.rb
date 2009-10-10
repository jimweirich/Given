#!/usr/bin/env ruby

require 'given'

module Given
  module Framework
    class TestCase
      extend Given::DSL

      def initialize(name)
        @name = name
      end

      def run
        self.send(@name)
      end
      
      def self.given_test_methods
        instance_methods(false).grep(/^test_/).map { |m| m.to_sym }
      end
      
      def self.suite
        given_test_methods.inject(Given::Framework::Suite.new) { |s,m| s << new(m) }
      end
    end
  end
end
