# frozen_string_literal: true

require_relative './worksheet_base'

module AspireBudgetWrapper
  module Worksheets
    class BackendData < WorksheetBase
      WS_TITLE = 'BackendData'

      def categories
        fetch_data(data_title: 'Categories')
      end

      def fetch_data(data_title: 'Categories')
        col = (1..ws.num_cols).find_index do |i|
          ws[1, i] == data_title
        end

        ws.rows.transpose[col].reject(&:empty?) - [data_title]
      end
    end
  end
end
