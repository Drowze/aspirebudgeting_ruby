# frozen_string_literal: true

require 'date'

class GoogleDriveMock
  def self.from_config(_)
    Session.new
  end

  class Session
    def spreadsheet_by_key(version = 'v3-2-0')
      Spreadsheet.new(version)
    end
  end

  class Spreadsheet
    def initialize(version)
      @version = version
    end

    def title
      "aspire budget #{@version}"
    end

    def id
      @version
    end

    def worksheets
      @worksheets ||= ['Transactions', 'Category Transfers', 'BackendData'].map do |title|
        filename = title.downcase.gsub(' ', '_') + '.json'
        Worksheet.new(
          title,
          JSON.parse(File.read(__dir__ + "/../fixtures/#{@version}/#{filename}"))
        )
      end
    end
  end

  class Worksheet
    CURRENCY_REGEX = /^[$̂€]?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$/.freeze
    LOTUS_DAY_ONE = Date.new(1899, 12, 30).freeze
    DATE_FORMAT = '%d/%m/%y'

    attr_reader :title

    def initialize(title, rows)
      @title = title
      @rows = rows
    end

    def rows(skip = 0)
      @rows.drop(skip)
    end

    def rows_with_numerics(skip = 0)
      nc = num_cols
      ((1 + skip)..num_rows).map do |row|
        (1..nc).map { |col| numeric_value(row, col) || self[row, col] }.freeze
      end.freeze
    end

    def synchronize
      @dirty = false
    end

    def dirty?
      @dirty
    end

    def num_rows
      rows.size
    end

    def num_cols
      rows.first.size
    end

    def [](*args)
      row, col =
        if args.size == 1
          raise 'Invalid cell' unless args.first.match?(/^[A-Z]\d+$/)

          # convert 'A1' to [1, 1]
          [args.first[0].ord - 64, args.first[1..-1].to_i]
        else
          args
        end

      rows[row - 1][col - 1]
    end

    def []=(row, col, value) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @dirty = true

      if row > num_rows
        new_rows = Array.new(row - num_rows, Array.new([col, num_cols].max, ''))
        @rows.push(*new_rows)
      end

      if col > num_cols
        @rows.each do |existing_row|
          new_cols = Array.new(col - num_rows, '')
          existing_row.push(new_cols)
        end
      end

      value = treat_value(row, col, value) || value

      @rows[row - 1][col - 1] = value.to_s
    end

    # treat the values (e.g. convert to date or currency)
    # used by #treat_cells_as test helper
    def treat_value(row, col, value); end

    # assumes that "," is not a decimal separator
    # assumes date format as defined above
    def numeric_value(*args)
      value = self[*args].to_s
      if value.match?(CURRENCY_REGEX)
        Float(value.gsub(/[€$,]/, ''))
      elsif value.match?(%r{\d+/\d+/\d+})
        Float(Date.strptime(value, DATE_FORMAT) - LOTUS_DAY_ONE)
      end
    end

    def update_cells(starting_row, starting_col, matrix)
      matrix.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          self[i + starting_row, j + starting_col] = cell
        end
      end
    end
  end
end
