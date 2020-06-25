# frozen_string_literal: true

module AspireBudgetWrapper
  module Utils
    def self.parse_date(value)
      Date.strptime(value, '%d/%m/%y')
    end

    def self.parse_currency(value)
      Float(value && value[/\d+\.\d+/] || 0)
    end

    def self.parse_status(value)
      transaction_status_mapping.fetch(value)
    end

    def self.transaction_status_mapping
      {
        '✅' => :approved,
        '🅿️' => :pending,
        '*️⃣' => :reconciliation
      }
    end
  end
end
