# frozen_string_literal: true

require 'date'
require 'worksheets/transactions'

RSpec.describe AspireBudget::Worksheets::Transactions do
  describe '#all' do
    before do
      AspireBudget.configure do |config|
        config.session = GoogleDrive.from_config('foo')
        config.spreadsheet_key = 'abc123'
      end
    end

    it 'lists the transactions' do
      expect(described_class.all).to contain_exactly(
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
end
