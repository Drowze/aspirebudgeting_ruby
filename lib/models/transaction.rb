# frozen_string_literal: true

require 'utils'

module AspireBudget
  module Models
    class Transaction
      attr_reader :date, :outflow, :inflow, :category, :account, :memo, :status

      def self.from_row(header, row)
        params = header.zip(row).to_h

        params.tap do |h|
          h[:date] = Utils.parse_date(h[:date])
          h[:outflow] = Utils.parse_currency(h[:outflow])
          h[:inflow] = Utils.parse_currency(h[:inflow])
          h[:status] = Utils.parse_status(h[:status])
        end

        new(**params)
      end

      def initialize(date:, outflow:, inflow:, category:, account:, memo:, status:)
        @date = Utils.parse_date(date) || Date.today
        @outflow = outflow || 0.0
        @inflow = inflow || 0.0
        @category = category
        @account = account
        @memo = memo
        @status = status
      end

      def to_row(header)
        header.map do |h|
          value = send(h)
          next Utils.serialize_date(value) if h == :date
          next Utils.serialize_status(value) if h == :status
          next Utils.serialize_currency(value) if %i[inflow outflow].include?(h)

          value
        end
      end
    end
  end
end
