# frozen_string_literal: true

require 'date'
require 'worksheets/worksheet_base'

RSpec.describe AspireBudget::Worksheets::WorksheetBase do
  subject do
    Class.new(described_class) do
      def all
        ws.rows
      end

      private

      def ws_title
        'Dummy'
      end
    end
  end

  let(:configuration) { instance_double(AspireBudget::Configuration) }
  let(:dummy_agent) do
    title = 'Dummy'
    rows = [['Dummy text']]
    double(worksheets: [GoogleDriveMock::Worksheet.new(title, rows)])
  end

  before do
    allow(AspireBudget).to receive(:configuration).and_return(configuration)
    allow(configuration).to receive(:agent).and_return(dummy_agent)
  end

  describe '#ws' do
    context 'when #ws_title is defined' do
      it { expect { subject.instance.send(:ws) }.not_to raise_error }
    end

    context 'when #ws_title is not defined' do
      before { subject.send(:remove_method, :ws_title) }

      it { expect { subject.instance.send(:ws) }.to raise_error(NotImplementedError) }
    end
  end

  describe '.instance' do
    it 'returns an instance of the worksheet and memoizes it' do
      expect(subject.instance).to be(subject.instance)
      expect(subject.instance).to be_an_instance_of(subject)
    end
  end

  describe '.respond_to_missing?' do
    it 'delegates to the instance and fallback to the class' do
      expect(subject).to respond_to(:all)
      expect(subject).to respond_to(:instance)
    end
  end

  describe '.method_missing' do
    it 'delegates to the instance and fallback to the class' do
      expect(subject.all).to eq [['Dummy text']]
      expect { subject.asdf }.to raise_error(NoMethodError)
    end
  end

  describe '.initialize' do
    context 'when without arguments' do
      it 'configures an agent without a session/key' do
        subject.new
        expect(configuration).to have_received(:agent).once.with(session: nil, spreadsheet_key: nil)
      end
    end

    context 'when specifiying session and spreadsheet_key' do
      it 'configures an agent with the specified arguments' do
        subject.new(session: 'foo', spreadsheet_key: 'bar')
        expect(configuration).to have_received(:agent).once.with(session: 'foo', spreadsheet_key: 'bar')
      end
    end
  end
end
