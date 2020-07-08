# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:test)

if ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter %r{^/spec/}
  end
end

require 'support/google_drive_mock'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before do
    stub_const('GoogleDrive', GoogleDriveMock)
  end
end
