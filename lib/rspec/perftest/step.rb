module RSpec
  module Perftest
    class Step
      attr_reader :name

      def initialize(name, options, block)
        @name = name
        @options = options
        @block = block
      end

      def limit
        @options[:limit] || Float::INFINITY
      end

      def benchmark
        with_gc_stats do
          measure do
            @block.call
          end
        end
      end

      private

      def measure
        Benchmark.measure do
          yield
        end
      end

      def with_gc_stats
        GC::Profiler.enable
        GC.start
        result = yield
      ensure
        GC::Profiler.disable
        result
      end
    end
  end
end
