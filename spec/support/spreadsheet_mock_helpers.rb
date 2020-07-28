# frozen_string_literal: true

require 'utils'

module SpreadsheetMockHelpers
  def use_spreadsheet_version(version)
    AspireBudget.configure do |config|
      config.session = GoogleDrive.from_config('foo')
      config.spreadsheet_key = version
    end
  end

  # When inputing into a numeric cell, mock it first so we'll try to coerce its
  # contents.
  #
  # @param currency [Array] currency cells ([row, col] format)
  # @param date [Array] date cels ([row, col] format)
  def treat_cells_as(currency: [], date: [])
    allow_any_instance_of(GoogleDriveMock::Worksheet)
      .to receive(:treat_value) do |_obj, row, col, value|
        if date.include?([row, col])
          AspireBudget::Utils.parse_date(Float(value)).strftime('%-d/%-m/%y')
        elsif currency.include?([row, col])
          value = format('%<value>.2f', value: value)
          "$#{format('%<value>.2f', value: value)}"
        end
      end
  end
end

RSpec.configure do |config|
  config.include SpreadsheetMockHelpers
end
