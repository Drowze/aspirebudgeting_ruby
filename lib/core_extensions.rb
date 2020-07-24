# frozen_string_literal: true

require 'google_drive'

module AspireBudget
  module CoreExtensions
    # rubocop:disable all
    module Worksheet
      def rows(skip = 0)
        nc = num_cols
        result = ((1 + skip)..num_rows).map do |row|
          (1..nc).map do |col|
            block_given? ? yield(row, col) : self[row, col]
          end.freeze
        end
        result.freeze
      end

      # Same as +#rows+, but replacing cells with numeric values where they exist.
      # Please note that this will NOT replace dirty cells with their numeric
      # value.
      #
      # @see #rows
      # @see #numeric_value
      def rows_with_numerics(skip = 0)
        rows(skip) { |row, col| numeric_value(row, col) || self[row, col] }
      end

      def []=(*args) # rubocop:disable all
        (row, col) = parse_cell_args(args[0...-1])
        value = args[-1]

        reload_cells unless @cells
        @numeric_values[[row, col]] = value.is_a?(Numeric) ? value : nil
        value = value.to_s
        validate_cell_value(value)

        @cells[[row, col]] = value
        @input_values[[row, col]] = value
        @modified.add([row, col])
        self.max_rows = row if row > @max_rows
        self.max_cols = col if col > @max_cols
        if value.empty?
          @num_rows = nil
          @num_cols = nil
        else
          @num_rows = row if @num_rows && row > @num_rows
          @num_cols = col if @num_cols && col > @num_cols
        end
      end

      def save # rubocop:disable all
        sent = false

        if @meta_modified
          add_request({
            update_sheet_properties: {
              properties: {
                sheet_id: sheet_id,
                title: title,
                index: index,
                grid_properties: {row_count: max_rows, column_count: max_cols},
              },
              fields: '*',
            },
          })
        end

        if !@v4_requests.empty?
          self.spreadsheet.batch_update(@v4_requests)
          @v4_requests = []
          sent = true
        end

        @remote_title = @title

        unless @modified.empty?
          min_modified_row = 1.0 / 0.0
          max_modified_row = 0
          min_modified_col = 1.0 / 0.0
          max_modified_col = 0
          @modified.each do |r, c|
            min_modified_row = r if r < min_modified_row
            max_modified_row = r if r > max_modified_row
            min_modified_col = c if c < min_modified_col
            max_modified_col = c if c > max_modified_col
          end

          # Uses update_spreadsheet_value instead batch_update_spreadsheet with
          # update_cells. batch_update_spreadsheet has benefit that the request
          # can be batched with other requests. But it has drawback that the
          # type of the value (string_value, number_value, etc.) must be
          # explicitly specified in user_entered_value. Since I don't know exact
          # logic to determine the type from text, I chose to use
          # update_spreadsheet_value here.
          range = "'%s'!R%dC%d:R%dC%d" %
              [@title, min_modified_row, min_modified_col, max_modified_row, max_modified_col]
          values = (min_modified_row..max_modified_row).map do |r|
            (min_modified_col..max_modified_col).map do |c|
              next unless @modified.include?([r, c])

              @numeric_values[[r, c]] || @cells[[r, c]] || ''
            end
          end
          value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
          @session.sheets_service.update_spreadsheet_value(
              spreadsheet.id, range, value_range, value_input_option: 'USER_ENTERED')

          @modified.clear
          sent = true
        end

        sent
      end
    end
    # rubocop:enable all
  end
end

# https://github.com/gimite/google-drive-ruby/issues/378 (PR #377)
# https://github.com/gimite/google-drive-ruby/issues/380 (PR #379)
GoogleDrive::Worksheet.prepend AspireBudget::CoreExtensions::Worksheet
