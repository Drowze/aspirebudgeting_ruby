# frozen_string_literal: true

require 'aspire_budget/configuration'

RSpec.describe AspireBudget::Configuration do
  describe 'AspireBudget.configure' do
    it 'sets the configuration variables' do
      AspireBudget.configure do |config|
        config.session = GoogleDrive::Session.new(Object)
        config.spreadsheet_key = 'v3-2-0'
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
      AspireBudget.configure do |config|
        config.session = GoogleDrive::Session.new(Object)
        config.spreadsheet_key = 'v3-2-0'
      end

      expect { AspireBudget.reset! }
        .to change { AspireBudget.instance_variable_get(:@configuration) }
        .from(an_instance_of(described_class)).to(nil)
      expect { AspireBudget.configuration }
        .to change { AspireBudget.instance_variable_get(:@configuration) }
        .from(nil).to(an_instance_of(described_class))
      expect(AspireBudget.configuration)
        .to be(AspireBudget.instance_variable_get(:@configuration))
    end
  end

  describe '.agent' do
    context 'when not passing the configuration variables' do
      it 'uses the ones globally configured' do
        use_spreadsheet_version 'v3-2-0'

        expect(AspireBudget.configuration.agent(nil, nil)).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )
      end
    end

    context 'when passing the configuration variables' do
      it 'uses them' do
        session1 = GoogleDrive::Session.new(Object)
        session2 = GoogleDrive::Session.new(Object)

        agent1 = AspireBudget.configuration.agent(session1, 'v3-2-0')
        agent2 = AspireBudget.configuration.agent(session2, 'v3-1-0')

        expect(agent1).to have_attributes(
          id: 'v3-2-0',
          title: 'aspire budget v3-2-0'
        )

        expect(agent2).to have_attributes(
          id: 'v3-1-0',
          title: 'aspire budget v3-1-0'
        )
      end
    end
  end
end
