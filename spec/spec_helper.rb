# frozen_string_literal: true

require 'bundler/setup'

if ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'lib/core_extensions.rb'
    add_filter %r{^/spec/}
  end
end

require 'pry'
require 'google_drive'
require 'support/spreadsheet_mock_helpers'
require 'support/google_api_mock'
require 'aspire_budget'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    AspireBudget.reset!
    ss_repo = GoogleApiMock::SpreadsheetsRepo.new

    allow(Google::Apis::DriveV3::DriveService)
      .to receive(:new)
      .and_return(GoogleApiMock::DriveService.new(ss_repo))
    allow(Google::Apis::SheetsV4::SheetsService)
      .to receive(:new)
      .and_return(GoogleApiMock::SheetsService.new(ss_repo))
  end
end
