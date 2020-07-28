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
require 'support/google_drive_mock'
require 'support/spreadsheet_mock_helpers'
require 'aspire_budget'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    AspireBudget.reset!
    stub_const('GoogleDrive', GoogleDriveMock)
  end
end
