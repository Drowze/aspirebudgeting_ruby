# frozen_string_literal: true

module AspireBudget
  module Utils
    class << self
      DATE_FORMAT = '%d/%m/%y'
      CURRENCY_SYMBOL = '€'
      TRANSACTION_STATUS_MAPPING = {
        '✅' => :approved,
        '🅿️' => :pending,
        '*️⃣' => :reconciliation
      }.freeze

      def parse_date(value)
        return value unless value.is_a?(String)

        Date.strptime(value, DATE_FORMAT)
      end

      def serialize_date(value)
        return value unless value.respond_to?(:strftime)

        value.strftime(DATE_FORMAT)
      end

      def parse_currency(value)
        value && value[/\d+\.\d+/].to_f || 0.0
      end

      def serialize_currency(value)
        "#{CURRENCY_SYMBOL}#{format('%.2f', value)}"
      end

      def parse_status(value)
        TRANSACTION_STATUS_MAPPING.fetch(value, nil)
      end

      def serialize_status(value)
        TRANSACTION_STATUS_MAPPING.key(value) || ''
      end
    end
  end
end
