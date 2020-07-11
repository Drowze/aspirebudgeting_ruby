# frozen_string_literal: true

require 'date'
require 'utils'

RSpec.describe AspireBudget::Utils do
  describe '.parse_currency' do
    it 'parses correctly', :aggregate_failures do
      expect(described_class.parse_currency('1')).to eq 1.0
      expect(described_class.parse_currency('10')).to eq 10.0
      expect(described_class.parse_currency('100')).to eq 100.0
      expect(described_class.parse_currency('1000')).to eq 1000.0
      expect(described_class.parse_currency('1,000.00')).to eq 1000.0

      expect(described_class.parse_currency('€1,000.00')).to eq 1000.0

      expect(described_class.parse_currency(1)).to eq 1.0
      expect(described_class.parse_currency(10)).to eq 10.0
      expect(described_class.parse_currency(100)).to eq 100.0
      expect(described_class.parse_currency(1000)).to eq 1000.0
    end
  end
end
