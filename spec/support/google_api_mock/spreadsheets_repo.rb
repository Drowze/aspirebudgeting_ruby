# frozen_string_literal: true

require_relative './spreadsheet'

module GoogleApiMock
  class SpreadsheetsRepo
    def by_version(version, opts = {})
      @spreadsheets ||= Hash.new do |h, k|
        h[k] = Spreadsheet.new(k)
      end
      @spreadsheets[version].modify_sheet_order(opts)
    end
  end
end
