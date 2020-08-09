# frozen_string_literal: true

require_relative './row_data'

module GoogleApiMock
  class Sheet
    SheetProperties = Struct.new(:title, :index, :sheet_id, :grid_properties)
    GridData = Struct.new(:row_data)
    GridProperties = Struct.new(:row_count, :column_count)

    attr_reader :properties, :data

    def initialize(title, index, rows, cell_properties)
      rows_data = rows.map.with_index(1) do |row, row_no|
        RowData.new(row, row_no, 0, cell_properties)
      end

      @cell_properties = cell_properties
      @properties = SheetProperties.new(title, index, index, GridProperties.new(9000, 9000))
      @data = [GridData.new(rows_data)]
    end

    def update_cells(range, value_range) # rubocop:disable Metrics/AbcSize
      start_cell, end_cell = range.split(':')
      start_row, start_col = cell_to_row_col(start_cell)
      end_row, end_col = cell_to_row_col(end_cell)

      (end_row - row_size).times { add_blank_row } if end_row > row_size

      ((start_row - 1)..(end_row - 1)).each.with_index do |r, i|
        row_data = value_range.values.map.with_index do |row_values, row_delta|
          RowData.new(row_values, start_row + row_delta, start_col - 1, @cell_properties)
        end

        ((start_col - 1)..(end_col - 1)).each.with_index do |c, j|
          @data[0].row_data[r].values[c] = row_data[i].values[j]
        end
      end
    end

    private

    def add_blank_row
      values = Array.new(col_size, '')
      row_data = RowData.new(values, row_size, 0, @cell_properties)

      @data[0].row_data[row_size] = row_data
    end

    def add_blank_col
      # TODO
    end

    def cell_to_row_col(cell)
      cell.sub('R', '').split('C').map(&:to_i)
    end

    def row_size
      @data[0].row_data.size
    end

    def col_size
      @data[0].row_data[0].values.size
    end
  end
end
