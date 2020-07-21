# frozen_string_literal: true

require 'google_drive'

module AspireBudget
  module CoreExtensions
    module Worksheet
      def rows(skip = 0)
        nc = num_cols
        result = ((1 + skip)..num_rows).map do |row|
          (1..nc).map do |col|
            block_given? ? yield(row, col) : self[row, col]
          end.freeze
        end
        result.freeze
      end

      # Same as +#rows+, but replacing cells with numeric values where they exist.
      # Please note that this will NOT replace dirty cells with their numeric
      # value.
      #
      # @see #rows
      # @see #numeric_value
      def rows_with_numerics(skip = 0)
        rows(skip) { |row, col| numeric_value(row, col) || self[row, col] }
      end
    end
  end
end

# https://github.com/gimite/google-drive-ruby/issues/378 (PR #377)
GoogleDrive::Worksheet.prepend AspireBudget::CoreExtensions::Worksheet
