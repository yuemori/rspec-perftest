require 'rspec/core/formatters'
require 'rspec/core/formatters/documentation_formatter'
require 'terminal-table'

module RSpec
  module Perftest
    class Formatter < RSpec::Core::Formatters::DocumentationFormatter
      RSpec::Core::Formatters.register self, :benchmark, :example_passed

      def benchmark(notification)
        result = notification.benchmark
        step = notification.step

        row = [step.name, result.utime, result.stime, result.total, result.real]
        rows << row
      end

      def example_passed(_notification)
        table = Terminal::Table.new(
          rows: rows,
          headings: %w[name user system total real]
        )

        table.align_column(1, :right)

        out = table.to_s.split("\n").map do |line|
          current_indentation + line
        end.join("\n")

        output.write RSpec::Core::Formatters::ConsoleCodes.wrap(out, :success)
      ensure
        rows.clear
      end

      private

      def rows
        @rows ||= []
      end
    end
  end
end
