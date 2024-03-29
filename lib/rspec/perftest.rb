require "rspec/perftest/version"
require "rspec/perftest/step"
require "benchmark"
require "stackprof"

module RSpec
  module Perftest
    def self.included(base) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      base.extend ClassMethods

      base.class_eval do
        it 'benchmark' do
          self.class.steps.each do |step|
            result = step.benchmark(self)

            RSpec.configuration.reporter.publish(
              :benchmark,
              benchmark_result: result,
              step: step
            )

            expect(result.real).to be < step.limit
          end
        end

        it 'stackprof' do
          self.class.steps.each do |step|
            result = step.stackprof(self)

            RSpec.configuration.reporter.publish(
              :stackprof,
              stackprof_result: result,
              step: step
            )
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
