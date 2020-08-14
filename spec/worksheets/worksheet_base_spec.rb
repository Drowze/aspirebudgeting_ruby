# frozen_string_literal: true

require 'date'
require 'worksheets/worksheet_base'

RSpec.describe AspireBudget::Worksheets::WorksheetBase do
  subject do
    Class.new(described_class) do
      self::WS_TITLE = 'Dummy'

      def all
        ws.rows
      end
    end
  end

  before { use_spreadsheet_version 'ws_dummy' }

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

  describe '#spreadsheet_version' do
    before do
      backend_data = double
      allow(AspireBudget::Worksheets::BackendData)
        .to receive(:new)
        .with(agent: an_instance_of(GoogleDrive::Spreadsheet))
        .and_return(backend_data)
      allow(backend_data).to receive(:version).and_return('0.0.0')
    end

    it 'initializes the backenddata spreadsheet and calls #version on it' do
      expect(subject.spreadsheet_version).to eq '0.0.0'
    end
  end
end
