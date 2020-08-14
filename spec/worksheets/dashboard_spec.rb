# frozen_string_literal: true

RSpec.describe AspireBudget::Worksheets::Dashboard do
  context 'when on 3.2.0' do
    describe 'immediate methods' do
      before { use_spreadsheet_version 'v3-2-0' }

      it 'returns the expected values' do
        expect(subject.available_to_budget).to eq 11_505.0
        expect(subject.spent_this_month).to eq 0.0
        expect(subject.budgeted_this_month).to eq 0.0
        expect(subject.pending_transactions).to eq 0.0
      end
    end
  end

  context 'when on 3.1.0' do
    describe 'immediate methods' do
      before { use_spreadsheet_version 'v3-1-0' }

      it 'returns the expected values' do
        expect(subject.available_to_budget).to eq(-495.00) # TODO: fix inconsistency
        expect(subject.spent_this_month).to eq 0.0
        expect(subject.pending_transactions).to eq 0.0
      end

      it 'raises on unavailable methods' do
        expect { subject.budgeted_this_month }.to raise_error 'budgeted_this_month is not supported on 3.1.0'
      end
    end
  end
end
