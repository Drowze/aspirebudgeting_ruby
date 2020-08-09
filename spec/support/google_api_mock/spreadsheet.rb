# frozen_string_literal: true

require_relative './sheet'
require_relative './load_fixture'

module GoogleApiMock
  class Spreadsheet
    def initialize(version)
      @version = version
    end

    def name
      "aspire budget #{@version}"
    end

    def id
      @version
    end

    def mime_type
      'application/vnd.google-apps.spreadsheet'
    end

    def sheets
      @sheets ||=
        Fixtures.load_data(@version).map.with_index do |fixture_data, i|
          Sheet.new(
            fixture_data[:sheet_title],
            i,
            fixture_data[:fixture],
            fixture_data[:properties] || {}
          )
        end
    end

    def modify_sheet_order(opts)
      ranges = opts[:ranges]
      if ranges
        ranges.gsub!("'", '')
        first_sheet = sheets.find { |s| s.properties.title == ranges }
        sheets_without_first = sheets.reject { |s| s.properties.title == ranges }
        @sheets = [first_sheet, *sheets_without_first]
      end
      self
    end
  end
end
