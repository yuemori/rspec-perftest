require 'rspec/core/formatters'
require 'rspec/core/formatters/documentation_formatter'
require 'terminal-table'

module RSpec
  module Perftest
    class Formatter < RSpec::Core::Formatters::DocumentationFormatter
      RSpec::Core::Formatters.register self, :benchmark, :stackprof, :example_passed

      def benchmark(notification)
        rows << :benchmark if rows.empty?

        result = notification.benchmark_result
        step = notification.step

        row = [step.name, result.utime, result.stime, result.total, result.real]
        rows << row
      end

      def stackprof(notification)
        rows << :stackprof if rows.empty?

        report = StringIO.new

        StackProf::Report.new(notification.stackprof_result).print_text(
          false, # sort_by_total
          10, # limit
          nil, # select_files
          nil, # reject_files
          nil, # select_names
          nil, # reject_names
          report # f
        )

        report.rewind

        rows << [notification.step.name, report.read]
      end

      def example_passed(_notification)
        type = rows.first

        heading = case type
                  when :stackprof
                    %w[name, profile]
                  when :benchmark
                    %w[name user system total real]
                  end

        table = Terminal::Table.new(
          rows: rows[1..-1],
          headings: heading
        )
        table.style = { all_separators: true }

        out = table.to_s.split("\n").map do |line|
          current_indentation + line
        end.join("\n") + "\n\n"

        output.write RSpec::Core::Formatters::ConsoleCodes.wrap("#{type}\n", :success)
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
