# frozen_string_literal: true

require 'date'

module AspireBudget
  module Utils
    class << self
      # Parses a value to a date object
      # @return [Date]
      # @param value either a numeric object or an object responding to +to_date+
      def parse_date(value)
        return parse_serial_date(value) if value.is_a?(Numeric)
        return value.to_date if value.respond_to?(:to_date)

        raise 'Unsupported date format'
      end

      # Parses a value to a serial date
      # @return [Float]
      # @param value either a numeric object or an object responding to +to_date+
      def serialize_date(value)
        return Float(value) if value.is_a?(Numeric) && value >= 0

        value = value.to_date if value.respond_to?(:to_date)
        raise 'Unsupported date value' unless value.is_a?(Date)
        raise "Date should be after #{LOTUS_DAY_ONE}" if LOTUS_DAY_ONE > value

        Float(value - LOTUS_DAY_ONE)
      end

      # Parses a status icon
      # @return [Symbol]
      # @param value [String]
      def parse_status(value)
        TRANSACTION_STATUS_MAPPING.fetch(value, nil)
      end

      # Serialize a status symbol
      # @return [String]
      # @param value [Symbol]
      def serialize_status(value)
        TRANSACTION_STATUS_MAPPING.key(value) || ''
      end

      private

      TRANSACTION_STATUS_MAPPING = {
        '✅' => :approved,
        '🅿️' => :pending,
        '*️⃣' => :reconciliation
      }.freeze
      private_constant :TRANSACTION_STATUS_MAPPING

      LOTUS_DAY_ONE = Date.new(1899, 12, 30).freeze
      private_constant :LOTUS_DAY_ONE

      def parse_serial_date(days_after_lotus_day_one)
        LOTUS_DAY_ONE + days_after_lotus_day_one
      end
    end
  end
end
