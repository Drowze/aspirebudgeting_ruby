# frozen_string_literal: true

require_relative '../support/spreadsheet_mock_helpers'

require 'aspire_budget/configuration'

RSpec.describe AspireBudget::Configuration do
  include SpreadsheetMockHelpers

  describe 'AspireBudget.configure' do
    it 'sets the configuration variables' do
      config_params = worksheet_params_for('v3-2-0')

      AspireBudget.configure do |config|
        config.session = config_params[:session]
        config.spreadsheet_key = config_params[:spreadsheet_key]
      end

      expect(AspireBudget.configuration).to be_an_instance_of(described_class)
      expect(AspireBudget.configuration).to have_attributes(
        session: an_instance_of(GoogleDrive::Session),
        spreadsheet_key: 'v3-2-0'
      )
    end
  end

  describe 'AspireBudget.reset!' do
    it 'resets the configuration' do
      AspireBudget.configuration = worksheet_config_for('v3-2-0')

      expect { AspireBudget.reset! }
        .to change { AspireBudget.instance_variable_get(:@configuration) }
        .from(an_instance_of(described_class)).to(nil)
      expect { AspireBudget.configuration }
        .to change { AspireBudget.instance_variable_get(:@configuration) }
        .from(nil).to(an_instance_of(described_class))
    end
  end

  describe '.agent' do
    context 'when not passing the configuration variables' do
      it 'uses the ones globally configured' do
        AspireBudget.configuration = worksheet_config_for('v3-2-0')

        expect(AspireBudget.configuration.agent(nil, nil)).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )
      end
    end

    context 'when passing the configuration variables' do
      it 'uses them' do
        agent1 = AspireBudget.configuration.agent(*worksheet_params_for('v3-1-0').values)
        agent2 = AspireBudget.configuration.agent(*worksheet_params_for('v3-2-0').values)

        expect(agent1).to have_attributes(
          id: 'v3-1-0',
          title: 'aspire budget v3-1-0'
        )

        expect(agent2).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )
      end
    end
  end
end
