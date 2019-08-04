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

      def mode
        @options[:mode] || :cpu
      end

      def base_path
        @options[:base_path] || Pathname.new(Dir.pwd).join("tmp")
      end

      def benchmark(context)
        warmup_times.times { context.instance_eval(&@block) }

        result = Benchmark::Tms.new

        benchmark_times.times do
          with_gc_stats do
            result += measure do
              context.instance_eval(&@block)
            end
          end
        end

        result / benchmark_times
      end

      def stackprof_interval
        @options[:stackprof_interval] || 100
      end

      def stackprof_dir
        base_path.join("stackprof")
      end

      def stackprof_out
        stackprof_dir.join("#{name}.dump")
      end

      def stackprof(context)
        FileUtils.mkdir_p stackprof_dir.to_s

        with_gc_stats do
          StackProf.start(mode: mode, raw: true, interval: stackprof_interval)
          context.instance_eval(&@block)
          StackProf.stop
          StackProf.results
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
