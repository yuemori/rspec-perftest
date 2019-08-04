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

      def warmup_times
        @options[:warmup_times] || 5
      end

      def benchmark_times
        @options[:benchmark_times] || 10
      end

      def benchmark
        warmup_times.times { @block.call }

        result = Benchmark::Tms.new

        benchmark_times.times do
          with_gc_stats do
            result += measure do
              @block.call
            end
          end
        end

        result / benchmark_times
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
