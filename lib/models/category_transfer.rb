# frozen_string_literal: true

require 'utils'

module AspireBudget
  module Models
    class CategoryTransfer
      attr_reader :date, :amount, :from, :to, :memo

      def self.from_row(header, row)
        params = header.zip(row).to_h

        params.tap do |h|
          h[:date] = Utils.parse_date(h[:date])
          h[:amount] = Utils.parse_currency(h[:amount])
        end

        new(**params)
      end

      def initialize(date:, amount:, from:, to:, memo:)
        @date = Utils.parse_date(date) || Date.today
        @amount = amount
        @from = from || 'Available to Budget'
        @to = to
        @memo = memo
      end

      def to_row(header)
        header.map do |h|
          value = send(h)
          next Utils.serialize_date(value) if h == :date
          next Utils.serialize_currency(value) if h == :amount

          value
        end
      end
    end
  end
end
