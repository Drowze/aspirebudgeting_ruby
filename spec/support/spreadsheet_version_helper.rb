# frozen_string_literal: true

module SpreadsheetVersionHelper
  def use_spreadsheet_version(version)
    AspireBudget.configure do |config|
      config.session = GoogleDrive.from_config('foo')
      config.spreadsheet_key = version
    end
  end
end

RSpec.configure do |config|
  config.include SpreadsheetVersionHelper
end
