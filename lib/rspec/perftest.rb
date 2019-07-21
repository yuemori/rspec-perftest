require "rspec/perftest/version"
require "rspec/perftest/step"
require "benchmark"

module RSpec
  module Perftest
    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        it 'benchmark' do
          self.class.steps.each do |step|
            expect(step.benchmark.real).to be < step.limit
          end
        end
      end
    end

    module ClassMethods
      def step(name, options = {}, &block)
        steps << Step.new(name, options, block)
      end

      def steps
        @steps ||= []
      end
    end
  end
end
