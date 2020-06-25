# frozen_string_literal: true

require 'worksheets/worksheet_base'
require 'models/transaction'

module AspireBudgetWrapper
  module Worksheets
    class Transactions < WorksheetBase
      WS_TITLE = 'Transactions'
      MARGIN_LEFT = 1

      def all
        transaction_rows.map do |row|
          Models::Transaction.from_row(transactions_header, row)
        end
      end

      def insert(transaction, sync: true)
        row = transaction.to_row(transactions_header)
        ws.update_cells(ws.rows.size + 1, MARGIN_LEFT + 1, [row])
        ws.synchronize if sync
        Models::Transaction.from_row(transactions_header, sanitize(ws.rows.last))
      end

      private

      def sanitize(row)
        return if row.all?(&:empty?)

        row.drop(MARGIN_LEFT)
      end

      def transaction_rows
        ws.rows(transactions_header_location)
          .map(&method(:sanitize)).compact
      end

      def transactions_header
        @transactions_header ||=
          ws.rows(transactions_header_location - 1)
            .first
            .drop(MARGIN_LEFT)
            .map(&:downcase)
            .map(&:to_sym)
      end

      def transactions_header_location
        @transactions_header_location ||=
          ((MARGIN_LEFT + 1)..ws.num_rows).find { |i| ws[i, MARGIN_LEFT + 1] == 'DATE' }
      end
    end
  end
end
