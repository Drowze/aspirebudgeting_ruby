# frozen_string_literal: true

require 'bundler/setup'

if ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter %r{^/spec/}
  end
end

require 'pry'
require 'money'
require 'support/google_drive_mock'
require 'support/spreadsheet_version_helper'
require 'aspire_budget'

Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    AspireBudget.reset!
    stub_const('GoogleDrive', GoogleDriveMock)
  end
end
