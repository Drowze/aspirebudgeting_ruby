# frozen_string_literal: true

require 'date'
require 'worksheets/transactions'

RSpec.describe AspireBudget::Worksheets::Transactions do
  before do
    AspireBudget.configure do |config|
      config.session = GoogleDrive.from_config('foo')
      config.spreadsheet_key = 'abc123'
    end
  end

  describe '#all' do
    it 'lists the transactions' do
      expect(subject.all).to contain_exactly(
        an_object_having_attributes(
          account: 'Checking',
          category: 'Cosmetics',
          date: Date.parse('2020-06-03'),
          inflow: 0.to_f,
          outflow: 3.72,
          memo: 'Boots',
          status: :approved
        ),
        an_object_having_attributes(
          account: 'Checking',
          category: 'Groceries',
          date: Date.parse('2020-06-03'),
          inflow: 0.to_f,
          outflow: 10.to_f,
          memo: 'Tesco',
          status: :approved
        )
      )
    end
  end

  describe '#insert' do
    let(:params) do
      {
        date: '03/06/2020',
        outflow: 900,
        inflow: 800,
        category: 'Test',
        account: 'Checking',
        memo: 'ruby',
        status: :approved
      }
    end
    let(:new_record_attributes) do
      {
        date: Date.parse('2020-06-03'),
        outflow: 900.to_f,
        inflow: 800.to_f,
        category: 'Test',
        account: 'Checking',
        memo: 'ruby',
        status: :approved
      }
    end

    context 'when trying to insert a hash' do
      it 'inserts new data' do
        new_record = nil
        expect { new_record = subject.insert(params) }
          .to change { subject.all.size }
          .by(1)

        expect(new_record).to have_attributes(new_record_attributes)

        expect(subject).not_to be_dirty
      end
    end

    context 'when trying to insert a transaction object' do
      let(:transaction) do
        double(**new_record_attributes)
      end

      before do
        allow(transaction)
          .to receive(:to_row)
          .with(%i[date outflow inflow category account memo status])
          .and_return(['03/06/20', '900.00', '800.00', 'Test', 'Checking', 'ruby', '✅'])
      end

      it 'inserts new data' do
        new_record = nil
        expect { new_record = subject.insert(transaction) }
          .to change { subject.all.size }
          .by(1)

        expect(new_record).to have_attributes(new_record_attributes)

        expect(subject).not_to be_dirty
      end
    end
  end
end
