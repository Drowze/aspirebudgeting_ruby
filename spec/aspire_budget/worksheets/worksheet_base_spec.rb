# frozen_string_literal: true

require_relative '../../support/spreadsheet_mock_helpers'

require 'date'
require 'aspire_budget/worksheets/worksheet_base'

RSpec.describe AspireBudget::Worksheets::WorksheetBase do
  include SpreadsheetMockHelpers

  subject do
    Class.new(described_class) do
      self::WS_TITLE = 'Dummy'

      def all
        ws.rows
      end
    end
  end

  before do
    AspireBudget.configuration = worksheet_config_for('ws_dummy')
  end

  describe '.instance' do
    it 'returns an instance of the worksheet and memoizes it' do
      expect(subject.instance).to be(subject.instance)
      expect(subject.instance).to be_an_instance_of(subject)
    end

    it 'delegates missing methods to the instance' do
      expect(subject).to respond_to(:all)
      expect(subject.all).to eq [['Dummy text']]

      expect(subject).to respond_to(:instance)
      expect { subject.asdf }.to raise_error(NoMethodError)
    end
  end

  describe '.initialize' do
    context 'when without arguments' do
      it 'configures an agent without a session/key' do
        allow(AspireBudget.configuration).to receive(:agent)
        subject.new
        expect(AspireBudget.configuration).to have_received(:agent).once.with(nil, nil)
      end
    end

    context 'when specifiying session and spreadsheet_key' do
      it 'configures an agent with the specified arguments' do
        allow(AspireBudget.configuration).to receive(:agent)
        subject.new(session: 'foo', spreadsheet_key: 'bar')
        expect(AspireBudget.configuration).to have_received(:agent).once.with('foo', 'bar')
      end
    end
  end
end
