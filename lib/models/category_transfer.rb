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
        end

        new(**params)
      end

      def initialize(date:, amount:, from:, to:, memo:)
        @date = date.nil? ? Date.today : Utils.parse_date(date)
        @amount = amount.to_f
        @from = from || 'Available to Budget'
        @to = to
        @memo = memo
      end

      def to_row(header)
        header.map do |h|
          value = send(h)
          next Utils.serialize_date(value) if h == :date

          value
        end
      end
    end
  end
end
