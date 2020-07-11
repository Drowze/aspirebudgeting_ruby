# frozen_string_literal: true

require 'configuration'
require 'money'

RSpec.describe AspireBudget::Configuration do
  describe '.configure' do
    it 'sets the configuration variables' do
      AspireBudget.configure do |config|
        config.session = GoogleDrive.from_config('foo.json')
        config.spreadsheet_key = 'abc123'
        config.currency = 'USD'
      end

      expect(AspireBudget.configuration).to have_attributes(
        session: an_instance_of(GoogleDriveMock::Session),
        spreadsheet_key: 'abc123',
        currency: Money::Currency.new('USD')
      )
    end
  end
end
