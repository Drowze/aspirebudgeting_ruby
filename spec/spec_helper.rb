# frozen_string_literal: true

if ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'lib/aspire_budget/core_extensions.rb'
    add_filter %r{^/spec/}
    enable_coverage :branch
  end
end

require 'aspire_budget'

require 'google_drive'
require 'webmock/rspec'
require 'pry'

require_relative 'support/google_api_mock'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    ss_repo = GoogleApiMock::SpreadsheetsRepo.new

    allow(Google::Apis::DriveV3::DriveService)
      .to receive(:new)
      .and_return(GoogleApiMock::DriveService.new(ss_repo))
    allow(Google::Apis::SheetsV4::SheetsService)
      .to receive(:new)
      .and_return(GoogleApiMock::SheetsService.new(ss_repo))
  end
end
