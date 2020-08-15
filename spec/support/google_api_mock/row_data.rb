# frozen_string_literal: true

require_relative 'cell_data'

module GoogleApiMock
  class RowData
    include Enumerable

    attr_reader :values

    def initialize(row, row_no, col_delta, properties)
      @values = row.map.with_index(1) do |value, col_no|
        cell_property = properties.find { |_k, v| v.include?([row_no, col_no + col_delta]) }
        cell_format = cell_property ? cell_property.first.to_sym : :text
        CellData.new(value, cell_format)
      end
    end

    def size
      @values.size
    end

    def each(&block)
      @values.each(&block)
    end
  end
end
