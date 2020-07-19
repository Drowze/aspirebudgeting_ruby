# frozen_string_literal: true

require 'worksheets/worksheet_base'
require 'models/transaction'

module AspireBudget
  module Worksheets
    class Transactions < WorksheetBase
      WS_TITLE = 'Transactions'

      def all
        rows.map do |row|
          klass.from_row(header, row)
        end
      end

      def insert(record, sync: true)
        record = klass.new(**record) if record.is_a?(Hash)
        row = record.to_row(header)
        ws.update_cells(*next_row_col, [row])
        ws.synchronize if sync
        klass.from_row(header, sanitize(ws.rows.last))
      end

      private

      def klass
        Models::Transaction
      end

      # There is a 1 cell margin before the spreadsheet content
      def margin_left
        1
      end

      def next_row_col
        [ws.rows.size + 1, margin_left + 1]
      end

      def sanitize(row)
        return if row.all?(&:empty?)

        row.drop(margin_left)
      end

      def rows
        ws.rows(header_location)
          .map(&method(:sanitize)).compact
      end

      def header
        @header ||=
          ws.rows(header_location - 1)
            .first
            .drop(margin_left)
            .map(&:downcase)
            .map(&:to_sym)
      end

      def header_location
        @header_location ||=
          (1..ws.num_rows).find { |i| ws[i, margin_left + 1].casecmp?('date') }
      end
    end
  end
end
