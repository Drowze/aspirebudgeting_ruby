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
          h[:status] = Utils.parse_status(h[:status])
        end

        new(**params)
      end

      # rubocop:disable Metrics/ParameterLists
      def initialize(date:, outflow:, inflow:, category:, account:, memo:, status:)
        @date = date.nil? ? Date.today : Utils.parse_date(date)
        @outflow = outflow.to_f
        @inflow = inflow.to_f
        @category = category
        @account = account
        @memo = memo
        @status = status
      end
      # rubocop:enable Metrics/ParameterLists

      def to_row(header)
        header.map do |h|
          value = send(h)
          next Utils.serialize_date(value) if h == :date
          next Utils.serialize_status(value) if h == :status

          value
        end
      end
    end
  end
end
