# frozen_string_literal: true

require 'utils'

module AspireBudgetWrapper
  module Models
    class Transaction
      def self.from_row(**row)
        params = row.reduce({}) do |h, (header, value)|
          h.merge(header => parse_row_value(header, value))
        end

        new(**params)
      end

      def initialize(date:, outflow:, inflow:, category:, account:, memo:, status:)
        @date = date.is_a?(String) ? Utils.parse_date(date) : date
        @outflow = outflow
        @inflow = inflow
        @category = category
        @account = account
        @memo = memo
        @status = status
      end

      def self.parse_row_value(header, value)
        case header
        when :date
          Utils.parse_date(value)
        when :outflow, :inflow
          Utils.parse_currency(value)
        when :status
          Utils.parse_status(value)
        else
          value
        end
      end
    end
  end
end
