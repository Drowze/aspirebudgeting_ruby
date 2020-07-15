# frozen_string_literal: true

require_relative './worksheet_base'

module AspireBudget
  module Worksheets
    class BackendData < WorksheetBase
      WS_TITLE = 'BackendData'

      def version
        version_column = ws.rows[0].index { |header| header.match?(/Update/) }
        ws.rows[1][version_column]
      end
    end
  end
end
