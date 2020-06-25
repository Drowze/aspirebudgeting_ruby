# frozen_string_literal: true

require 'worksheets/worksheet_base'
require 'models/transaction'

module AspireBudgetWrapper
  module Worksheets
    class Transactions < WorksheetBase
      WS_TITLE = 'Transactions'

      def all
        parsed_transactions.map(&Models::Transaction.method(:from_row))
      end

      private

      def parsed_transactions
        transactions_rows.map do |r|
          transactions_header.zip(r).to_h
        end
      end

      def transactions_rows
        ws.rows[transactions_header_location..-1].map do |r|
          next if r.all?(&:empty?)

          r.drop(1)
        end.compact
      end

      def transactions_header
        ws.rows[transactions_header_location - 1]
          .drop(1)
          .map(&:downcase)
          .map(&:to_sym)
      end

      def transactions_header_location
        @transactions_header_location ||=
          (2..ws.num_rows).find { |i| ws[i, 2] == 'DATE' }
      end
    end
  end
end
