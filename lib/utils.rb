# frozen_string_literal: true

require 'date'
require 'configuration'
require 'monetize'

module AspireBudget
  module Utils
    class << self
      DATE_FORMAT = '%d/%m/%y'
      TRANSACTION_STATUS_MAPPING = {
        '✅' => :approved,
        '🅿️' => :pending,
        '*️⃣' => :reconciliation
      }.freeze

      def parse_date(value)
        return parse_serial_date(value) if value.is_a?(Numeric)
        return value.to_date if value.respond_to?(:to_date)

        raise 'Unsupported date format'
      end

      def serialize_date(value)
        return Float(value) if value.is_a?(Numeric) && value >= 0

        value = value.to_date if value.respond_to?(:to_date)
        raise 'Unsupported date value' unless value.is_a?(Date)
        raise "Date should be after #{LOTUS_DAY_ONE}" if LOTUS_DAY_ONE > value

        Float(value - LOTUS_DAY_ONE)
      end

      def parse_currency(value)
        value && Monetize.parse(value, AspireBudget.configuration.currency).to_f
      end

      def serialize_currency(value)
        format('%<value>.2f', value: value)
      end

      def parse_status(value)
        TRANSACTION_STATUS_MAPPING.fetch(value, nil)
      end

      def serialize_status(value)
        TRANSACTION_STATUS_MAPPING.key(value) || ''
      end

      private

      LOTUS_DAY_ONE = Date.new(1899, 12, 30).freeze
      private_constant :LOTUS_DAY_ONE

      def parse_serial_date(days_after_lotus_day_one)
        LOTUS_DAY_ONE + days_after_lotus_day_one
      end
    end
  end
end
