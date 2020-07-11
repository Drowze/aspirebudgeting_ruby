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
        TransactionsWorksheet.new,
        CategoryTransfersWorksheet.new
      ]
    end
  end

  class Worksheet
    def rows(skip = 0)
      @rows ||= _starting_data
      @rows.drop(skip)
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

    def [](row, col)
      rows[row - 1][col - 1]
    end

    def []=(row, col, value) # rubocop:disable Metrics/MethodLength
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

      @rows[row - 1][col - 1] = value
    end

    def update_cells(starting_row, starting_col, matrix)
      matrix.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          self[i + starting_row, j + starting_col] = cell
        end
      end
    end
  end

  class TransactionsWorksheet < Worksheet
    def title
      'Transactions'
    end

    private

    def _starting_data # rubocop:disable Metrics/MethodLength
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
      ]
    end
  end

  class CategoryTransfersWorksheet < Worksheet
    def title
      'Category Transfers'
    end

    private

    def _starting_data # rubocop:disable Metrics/MethodLength
      [
        ['', '', '', '', '', '', ''],
        ['', 'Category Transfers', '', '', 'Select a Category to view funding details', 'Monthly Amount', ''],
        ['', '', '', '', 'Other house expenses', '€60.00', ''],
        ['', 'Available to budget', '', 'DOL', 'To meet your monthly target for this category, budget another', '', ''],
        ['', '€100,000.00', '', 'DOL', '€60.00', '', ''],
        ['', '', '', '', '', '', ''],
        ['', 'DATE', 'AMOUNT', 'FROM CATEGORY', 'TO CATEGORY', 'MEMO', '✱'],
        ['', '29/5/20', '€500.00', 'Available to budget', 'Groceries', 'Monthly target', ''],
        ['', '29/5/20', '€1,200.00', 'Available to budget', 'Cosmetics', 'Monthly target', '']
      ]
    end
  end
end
