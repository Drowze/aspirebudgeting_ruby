# frozen_string_literal: true

require 'date'
require 'worksheets/category_transfers'

RSpec.describe AspireBudget::Worksheets::CategoryTransfers do
  before do
    AspireBudget.configure do |config|
      config.session = GoogleDrive.from_config('foo')
      config.spreadsheet_key = 'abc123'
    end
  end

  describe '#all' do
    it 'lists the transactions' do
      expect(described_class.all).to contain_exactly(
        an_object_having_attributes(
          date: Date.parse('2020-05-29'),
          amount: 500.to_f,
          from: 'Available to budget',
          to: 'Groceries',
          memo: 'Monthly target'
        ),
        an_object_having_attributes(
          date: Date.parse('2020-05-29'),
          amount: 1200.to_f,
          from: 'Available to budget',
          to: 'Cosmetics',
          memo: 'Monthly target'
        )
      )
    end
  end

  describe '#insert' do
    let(:params) do
      { date: '03/06/2020', amount: 120.43, from: 'Available to budget', to: 'Groceries', memo: 'ruby' }
    end
    let(:new_record_attributes) do
      {
        date: Date.parse('2020-06-03'),
        amount: 120.43,
        from: 'Available to budget',
        to: 'Groceries',
        memo: 'ruby'
      }
    end

    context 'when trying to insert a hash' do
      it 'inserts new data' do
        new_record = nil
        expect { new_record = described_class.insert(params) }
          .to change { described_class.all.size }
          .by(1)

        expect(new_record).to have_attributes(new_record_attributes)

        expect(described_class).not_to be_dirty
      end
    end

    context 'when trying to insert a category_transfer object' do
      let(:category_transfer) do
        double(**new_record_attributes)
      end

      before do
        allow(category_transfer)
          .to receive(:to_row)
          .with(%i[date amount from to memo])
          .and_return(['03/06/20', '120.43', 'Available to budget', 'Groceries', 'ruby'])
      end

      it 'inserts new data' do
        new_record = nil
        expect { new_record = described_class.insert(category_transfer) }
          .to change { described_class.all.size }
          .by(1)

        expect(new_record).to have_attributes(new_record_attributes)

        expect(described_class).not_to be_dirty
      end
    end
  end
end
