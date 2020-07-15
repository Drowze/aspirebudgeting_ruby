# frozen_string_literal: true

require 'date'
require 'worksheets/transactions'

RSpec.describe AspireBudget::Worksheets::Transactions do
  %w[v3-2-0 v3-1-0].each do |version|
    let(:aspire_version) { version }

    context "When using #{version}" do
      before { use_spreadsheet_version(aspire_version) }

      describe '#all' do
        it 'lists the transactions' do
          expect(subject.all).to contain_exactly(
            an_object_having_attributes(
              account: '💰 Checking',

              # Aspire added the category 'starting on balance' on v3-2-0
              category: aspire_version == 'v3-2-0' ? '➡️ Starting Balance' : '🔢 Balance Adjustment',
              date: Date.parse('2020-06-03'),
              inflow: 12_000.to_f,
              outflow: 0.to_f,
              memo: '',
              status: :approved
            ),
            an_object_having_attributes(
              account: '💰 Checking',
              category: 'Electric Bill',
              date: Date.parse('2020-06-03'),
              inflow: 0.to_f,
              outflow: 100.to_f,
              memo: '',
              status: :approved
            ),
            an_object_having_attributes(
              account: '💰 Checking',
              category: 'Groceries',
              date: Date.parse('2020-06-03'),
              inflow: 0.to_f,
              outflow: 10.to_f,
              memo: 'Tesco',
              status: :approved
            ),
            an_object_having_attributes(
              account: '',
              category: '',
              date: Date.parse('2020-06-07'),
              inflow: 0.to_f,
              outflow: 0.to_f,
              memo: '',
              status: :reconciliation
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
            account: '💰 Checking',
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
            account: '💰 Checking',
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
              .and_return(['03/06/20', '900.00', '800.00', 'Test', '💰 Checking', 'ruby', '✅'])
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
  end
end
