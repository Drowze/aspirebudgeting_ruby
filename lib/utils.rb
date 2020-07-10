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
        return value unless value.is_a?(String)

        Date.strptime(value, DATE_FORMAT)
      end

      def serialize_date(value)
        return value unless value.respond_to?(:strftime)

        value.strftime(DATE_FORMAT)
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
    end
  end
end
