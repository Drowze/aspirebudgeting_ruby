# frozen_string_literal: true

require 'date'
require 'utils'

RSpec.describe AspireBudget::Utils do
  describe '.parse_date' do
    context 'when value is a float' do
      it 'coverts it using "days after lotus day one"' do
        expect(described_class.parse_date(0.0)).to eq Date.new(1899, 12, 30)
        expect(described_class.parse_date(25_569.0)).to eq Date.new(1970, 1, 1)
      end
    end

    context 'when value is an object that responds to #to_date' do
      it 'converts it' do
        object = double(to_date: Date.new(1899, 12, 30))
        expect(described_class.parse_date(object)).to eq Date.new(1899, 12, 30)
      end
    end

    context 'when value is not supported' do
      it { expect { described_class.parse_date(nil) }.to raise_error('Unsupported date format') }
    end
  end

  describe '.serialize_date' do
    context 'when it does not represent a valid date' do
      it 'raises error' do
        expect { described_class.serialize_date(Object) }.to raise_error('Unsupported date value')
        expect { described_class.serialize_date(-1) }.to raise_error('Unsupported date value')
        expect { described_class.serialize_date(Date.new(1899, 12, 29)) }
          .to raise_error('Date should be after 1899-12-30')
        expect { described_class.serialize_date(double(to_date: Date.new(1899, 12, 29))) }
          .to raise_error('Date should be after 1899-12-30')
      end
    end

    context 'when value is a numeric >= 0' do
      it 'coerse to a float and returns it' do
        expect(described_class.serialize_date(0)).to be 0.0
        expect(described_class.serialize_date(25_569.3)).to be 25_569.3
      end
    end

    context 'when value responds to #to_date' do
      it 'converts to its serial form' do
        date = Date.new(1899, 12, 30)
        expect(described_class.serialize_date(date)).to be 0.0
        expect(described_class.serialize_date(double(to_date: date))).to be 0.0

        date = Date.new(1970, 1, 1)
        expect(described_class.serialize_date(date)).to be 25_569.0
        expect(described_class.serialize_date(double(to_date: date))).to be 25_569.0
      end
    end
  end
end
