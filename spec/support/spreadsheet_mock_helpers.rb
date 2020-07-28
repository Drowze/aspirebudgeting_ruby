# frozen_string_literal: true

require 'utils'

module SpreadsheetMockHelpers
  def use_spreadsheet_version(version)
    AspireBudget.configure do |config|
      config.session = GoogleDrive::Session.new(Object)
      config.spreadsheet_key = version
    end
  end
end

RSpec.configure do |config|
  config.include SpreadsheetMockHelpers
end
