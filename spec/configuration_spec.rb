# frozen_string_literal: true

require 'configuration'
require 'money'

RSpec.describe AspireBudget::Configuration do
  describe '.configure' do
    it 'sets the configuration variables' do
      AspireBudget.configure do |config|
        config.session = GoogleDrive.from_config('foo.json')
        config.spreadsheet_key = 'v3-2-0'
        config.currency = 'USD'
      end

      expect(AspireBudget.configuration).to have_attributes(
        session: an_instance_of(GoogleDriveMock::Session),
        spreadsheet_key: 'v3-2-0',
        currency: Money::Currency.new('USD')
      )
    end
  end

  describe '.configuration.agent' do
    context 'when not passing the configuration variables' do
      it 'uses the ones globally configured' do
        use_spreadsheet_version 'v3-2-0'

        expect(AspireBudget.configuration.agent).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )
      end
    end

    context 'when passing the configuration variables' do
      it 'uses them' do
        session_1 = GoogleDrive.from_config('foo.json')
        session_2 = GoogleDrive.from_config('bar.json')

        agent_1 = AspireBudget.configuration.agent(session: session_1, spreadsheet_key: 'v3-2-0')
        agent_2 = AspireBudget.configuration.agent(session: session_2, spreadsheet_key: 'v3-1-0')

        expect(agent_1).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )

        expect(agent_2).to have_attributes(
          id: 'v3-1-0',
          title: 'aspire budget v3-1-0'
        )
      end
    end
  end
end
