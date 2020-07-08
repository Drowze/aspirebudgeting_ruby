# frozen_string_literal: true

class GoogleDriveMock
  def self.from_config(_)
    Session.new
  end

  class Session
    def spreadsheet_by_key(_)
      Spreadsheet.new
    end
  end

  class Spreadsheet
    def title
      'Finances'
    end

    def worksheets
      @worksheets ||= [
        TransactionsWorksheet.new
      ]
    end
  end

  class Worksheet
    def synchronize; end

    def num_rows
      rows.size
    end

    def num_cols
      rows.first.size
    end

    def [](row, col)
      rows[row - 1][col - 1]
    end

    def update_cells(starting_row, starting_col, arr)
      if starting_row > num_rows
        new_rows = Array.new(starting_row - num_rows, Array.new(num_cols, ''))
        @rows.push(*new_rows)
      end

      arr.each do |row|
        @rows[starting_row - 1][starting_col - 1, row.size] = row
      end
    end
  end

  class TransactionsWorksheet < Worksheet
    def title
      'Transactions'
    end

    def rows(skip = 0) # rubocop:disable Metrics/MethodLength
      @rows ||= [
        ['', 'Transactions', '', '', '', '', '', ''],
        ['', '', '', '', '', '', '', ''],
        ['', '', '', '', '', 'Select a Category to view activity data', 'Current Category balance', ''],
        ['', 'Accounts last reconciled on', '', '', '', 'Available to budget', '€0.00', ''],
        ['', '6/7/20', '', '', '', '', '', '2'],
        ['', '', '', '', '', '', '', ''],
        ['', '', '', '', '', '', '', ''],
        ['', 'DATE', 'OUTFLOW', 'INFLOW', 'CATEGORY', 'ACCOUNT', 'MEMO', 'STATUS'],
        ['', '3/6/20', '€3.72', '', 'Cosmetics', 'Checking', 'Boots', '✅'],
        ['', '3/6/20', '€10.00', '', 'Groceries', 'Checking', 'Tesco', '✅']
      ]
      @rows.drop(skip)
    end
  end
end
