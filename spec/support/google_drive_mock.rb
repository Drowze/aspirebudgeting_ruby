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
    def num_rows
      rows.size
    end

    def [](row, col)
      rows[row - 1][col - 1]
    end
  end

  class TransactionsWorksheet < Worksheet
    def title
      'Transactions'
    end

    def rows(skip = 0) # rubocop:disable Metrics/MethodLength
      [
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
      ].drop(skip)
    end
  end
end
