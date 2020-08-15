# frozen_string_literal: true

require 'date'
require 'aspire_budget/worksheets/backend_data'

RSpec.describe AspireBudget::Worksheets::BackendData do
  describe '#version' do
    context 'when the spreadsheet version is 3.1.0' do
      before { use_spreadsheet_version 'v3-1-0' }

      it { expect(subject.version).to eq '3.1.0' }
    end

    context 'when the spreadsheet version is 3.2.0' do
      before { use_spreadsheet_version 'v3-2-0' }

      it { expect(subject.version).to eq '3.2.0' }
    end
  end
end
