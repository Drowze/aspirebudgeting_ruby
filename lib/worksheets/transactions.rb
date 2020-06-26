# frozen_string_literal: true

require 'worksheets/worksheet_base'
require 'models/transaction'

module AspireBudget
  module Worksheets
    class Transactions < WorksheetBase
      WS_TITLE = 'Transactions'
      MARGIN_LEFT = 1

      def all
        rows.map do |row|
          klass.from_row(header, row)
        end
      end

      def insert(record, sync: true)
        row = record.to_row(header)
        ws.update_cells(*next_row_col, [row])
        ws.synchronize if sync
        klass.from_row(header, sanitize(ws.rows.last))
      end

      private

      def klass
        Models::Transaction
      end

      def next_row_col
        [ws.rows.size + 1, MARGIN_LEFT + 1]
      end

      def sanitize(row)
        return if row.all?(&:empty?)

        row.drop(MARGIN_LEFT)
      end

      def rows
        ws.rows(header_location)
          .map(&method(:sanitize)).compact
      end

      def header
        @header ||=
          ws.rows(header_location - 1)
            .first
            .drop(MARGIN_LEFT)
            .map(&:downcase)
            .map(&:to_sym)
      end

      def header_location
        @header_location ||=
          ((MARGIN_LEFT + 1)..ws.num_rows).find { |i| ws[i, MARGIN_LEFT + 1] == 'DATE' }
      end
    end
  end
end
